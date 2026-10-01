_:

{
  flake.modules.homeManager."lang.node" =
    { pkgs, lib, ... }:
    let
      # astro/svelte language servers need a TypeScript SDK to fall back on.
      # Under Nix there is no global `typescript`, so we expose its path explicitly.
      # `pkgs.typescript` now points at typescript_7 (the Go-based native compiler,
      # https://github.com/microsoft/typescript-go), which ships only a `tsc` binary
      # and .d.ts libs — no lib/node_modules/typescript/lib/tsserverlibrary.js. vtsls
      # (and astro/svelte's ts-plugins) need that classic JS TSDK, so pin to
      # typescript_5 explicitly instead of the `typescript` alias.
      tsdkPath = "${pkgs.typescript_5}/lib/node_modules/typescript/lib";
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
      svelteLanguageServer = pkgs.callPackage ./_svelte-language-server.nix { };
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
      programs.mise.globalConfig.tools = {
        deno = "2.8.0";
        pnpm = "12.4.2";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin { node = "24.15.0"; };

      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.nodejs_24 ];

      programs.neovim = {
        extraWrapperArgs = [
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
          # NOTE: deno (denols) is provided via mise, not Nix.
          svelteLanguageServer
          astro-language-server
          vtsls
          tailwindcss-language-server
          # TypeScript SDK that astro/svelte language servers fall back on (TSDK_PATH).
          # Must be the classic JS TSDK (typescript_5), not the `typescript` alias
          # (typescript_7, the Go-based native compiler) — see tsdkPath above.
          typescript_5

          # frontend formatting (JS/TS/CSS/HTML/JSON/YAML/Markdown/Svelte/Astro)
          # NOTE: eslint (linting) is expected to come from each project's own
          # node_modules; vscode-eslint-language-server (editor.neovim) resolves it there.
          prettier
        ];
      };
    };
}
