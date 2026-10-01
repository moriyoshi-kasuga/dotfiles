# nixpkgs' svelte-language-server derivation only builds the
# `svelte-language-server...` pnpm workspace filter, which excludes the
# sibling `typescript-svelte-plugin` package (unlike astro-language-server,
# which explicitly builds its `@astrojs/ts-plugin`). Without it, vtsls has
# no way to see .svelte usages, so plain .ts files get incomplete
# references/rename results. Build it ourselves: the pnpm lockfile subset
# fetched for `svelte-language-server...` already covers its deps, so no
# pnpmDeps hash change is needed. Its tsconfig relies on TypeScript's
# automatic @types inclusion, which doesn't reach across the pnpm
# symlink boundary into packages/typescript-plugin/node_modules/@types;
# pass --types node explicitly to compile as if @types/node were found.
{ svelte-language-server }:

svelte-language-server.overrideAttrs (old: {
  pnpmWorkspaces = old.pnpmWorkspaces ++ [ "typescript-svelte-plugin" ];
  buildPhase =
    old.buildPhase
    + "\n(cd packages/typescript-plugin && ../../node_modules/.bin/tsc -p ./ --types node)\n";
  # installPhase's `pnpm install --filter=svelte-language-server...` only
  # links workspace deps (svelte2tsx, @jridgewell/sourcemap-codec) into
  # svelte-language-server's own node_modules, not typescript-plugin's.
  # Without those symlinks, tsserver's `require("svelte2tsx")` inside the
  # plugin fails silently and it never loads, so plain .ts files can't
  # see .svelte usages. Add typescript-svelte-plugin to the install
  # filter too so pnpm links its workspace deps as well.
  #
  # svelte2tsx itself does `import { parse } from 'svelte/compiler'` at
  # module load time (packages/svelte2tsx/src/svelte2tsx/index.ts), and
  # `svelte` is only a peerDependency/devDependency there, never a real
  # dependency of any workspace package. The `--prod` install above
  # therefore never links a `svelte` package anywhere Node can find it
  # from svelte2tsx's own file, so `require("svelte2tsx")` throws
  # "Cannot find module 'svelte/compiler'" and the whole plugin fails to
  # load. (Per-project resolution isn't the issue: typescript-plugin
  # separately resolves the *project's* svelte via
  # `require.resolve('svelte/compiler', { paths: [projectDir] })` and
  # injects it per-file — but only after the module has loaded.)
  # A `svelte` tarball is already pulled into the local pnpm store
  # (it's svelte2tsx's own devDependency, used for its build/tests), so
  # we could link it in with a second `pnpm install` scoped to just
  # `svelte2tsx` — except pnpm's filtered install treats any workspace
  # package outside the current `--filter` set as unselected and wipes
  # its node_modules, which would undo the typescript-svelte-plugin
  # linking the first install just did (confirmed by testing: it left
  # packages/typescript-plugin/node_modules empty). A plain symlink
  # from the still-present `.pnpm` store avoids re-invoking pnpm.
  installPhase =
    builtins.replaceStrings
      [
        "pnpm install --filter=svelte-language-server... --prod --frozen-lockfile --offline --force --ignore-scripts"
      ]
      [
        ''
          pnpm install --filter=svelte-language-server... --filter=typescript-svelte-plugin --prod --frozen-lockfile --offline --force --ignore-scripts
          svelteStoreEntry=$(cd node_modules/.pnpm && ls -d svelte@*/node_modules/svelte | head -1)
          ln -s "../../../node_modules/.pnpm/$svelteStoreEntry" packages/svelte2tsx/node_modules/svelte
        ''
      ]
      old.installPhase;

})
