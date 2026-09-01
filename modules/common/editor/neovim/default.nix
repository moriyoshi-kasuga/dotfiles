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
      # Lets vtsls load astro's tsserver plugin so plain .ts/.js files can see
      # types from imported .astro components (bundled inside the LSP package).
      astroTsPluginPath = "${pkgs.astro-language-server}/lib/node_modules/astro-language-server/packages/language-tools/ts-plugin";
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
          svelte-language-server
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
