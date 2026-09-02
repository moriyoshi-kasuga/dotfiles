_:

{
  flake.modules.homeManager."editor.neovim" =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      treesitter = pkgs.vimPlugins.nvim-treesitter;
      treesitterGrammars = treesitter.withAllGrammars;
      grammarsPath = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths = treesitterGrammars.dependencies;
      };
      neovim = pkgs.neovim-unwrapped;
      neovimCmd = pkgs.lib.getExe neovim;
      # astro/svelte language servers need a TypeScript SDK to fall back on.
      # Under Nix there is no global `typescript`, so we expose its path explicitly.
      tsdkPath = "${pkgs.typescript}/lib/node_modules/typescript/lib";
      # vtsls forwards these paths to tsserver as `pluginProbeLocations` entries,
      # and tsserver resolves each plugin as `require(<path>/node_modules/<name>)`
      # (verified by direct tsserver testing) — it does NOT `require(<path>)`
      # directly. So `location` must be a directory whose node_modules contains
      # the plugin under its declared package name, not the plugin's own root.
      # Neither astro's ts-plugin (directory `ts-plugin`, declared name
      # `@astrojs/ts-plugin`) nor svelte's (directory `typescript-plugin`,
      # declared name `typescript-svelte-plugin`) match on their own, so wrap
      # each in a tiny node_modules layout that does.
      mkTsPluginProbe =
        {
          name,
          pkgName,
          target,
        }:
        pkgs.runCommand "${name}-probe" { } ''
          mkdir -p "$out/node_modules/$(dirname "${pkgName}")"
          ln -s ${target} "$out/node_modules/${pkgName}"
        '';

      # Lets vtsls load astro's tsserver plugin so plain .ts/.js files can see
      # types from imported .astro components (bundled inside the LSP package).
      astroTsPluginProbe = mkTsPluginProbe {
        name = "astro-ts-plugin";
        pkgName = "@astrojs/ts-plugin";
        target = "${pkgs.astro-language-server}/lib/node_modules/astro-language-server/packages/language-tools/ts-plugin";
      };
      astroTsPluginPath = "${astroTsPluginProbe}";
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
      svelteLanguageServer = pkgs.svelte-language-server.overrideAttrs (old: {
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

      });
      # Lets vtsls see through .svelte imports from plain .ts/.js files (same
      # pluginProbeLocations quirk as astroTsPluginProbe above).
      svelteTsPluginProbe = mkTsPluginProbe {
        name = "svelte-ts-plugin";
        pkgName = "typescript-svelte-plugin";
        target = "${svelteLanguageServer}/lib/node_modules/svelte-language-server/packages/typescript-plugin";
      };
      svelteTsPluginPath = "${svelteTsPluginProbe}";
    in
    {
      catppuccin.nvim.enable = false;

      programs.mise.globalConfig.tools = {
        tree-sitter = "0.26.8";
      };

      programs.neovim = {
        enable = true;
        package = neovim;

        extraWrapperArgs = [
          "--set"
          "TREESITTER_PATH"
          "${treesitter}/runtime"
          "--set"
          "TREESITTER_GRAMMARS"
          "${grammarsPath}"
          "--set"
          "TSDK_PATH"
          tsdkPath
          "--set"
          "ASTRO_TS_PLUGIN_PATH"
          astroTsPluginPath
          "--set"
          "SVELTE_TS_PLUGIN_PATH"
          svelteTsPluginPath
        ];

        extraPackages = with pkgs; [
          # shell
          bash-language-server
          shellcheck
          shfmt

          # lua
          lua-language-server
          stylua

          # python
          ty
          ruff

          # ts
          # NOTE: deno (denols) is provided via mise, not Nix.
          svelteLanguageServer
          astro-language-server
          vtsls
          tailwindcss-language-server
          # TypeScript SDK that astro/svelte language servers fall back on (TSDK_PATH).
          typescript

          # HTML/CSS/JSON
          vscode-langservers-extracted

          # frontend formatting (JS/TS/CSS/HTML/JSON/YAML/Markdown/Svelte/Astro)
          # NOTE: eslint (linting) is expected to come from each project's own
          # node_modules; vscode-eslint-language-server above resolves it there.
          prettier

          # nix
          nixd
          nixfmt

          # elm
          elmPackages.elm-language-server
          elmPackages.elm-format

          # single package for each lang
          fsautocomplete
          just-lsp
          hadolint
          actionlint
          gopls
          asm-lsp
          taplo
          tinymist
          clang-tools
        ];
      };

      home.packages = [
        (pkgs.writeShellScriptBin "simplenvim" ''
          env NVIM_SIMPLE_MODE=1 ${neovimCmd} "$@"
        '')
      ];

      home.shellAliases = {
        v = "nvim";
        todo = "simplenvim ~/todo.md";
      };

      home.sessionVariables = {
        MANPAGER = "simplenvim +Man!";
        EDITOR = "simplenvim";
      };

      # Prevent programs.neovim from generating init.lua inside the symlinked dir.
      # home-manager sorts files by path length and processes .config/nvim first,
      # so realpath -m on .config/nvim/init.lua resolves through the out-of-store
      # symlink to /home/mori/dotfiles/nvim-config/init.lua — outside $realOut.
      xdg.configFile."nvim/init.lua" = lib.mkForce { enable = false; };

      home.file.".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim-config";
    };
}
