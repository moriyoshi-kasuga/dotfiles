{
  pkgs,
  mkModule,
  homeDirectory,
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

  Lombok = pkgs.lombok;
in
mkModule {
  name = "editor.neovim";
  inheritModule = "editor";
  homeModule =
    { config, ... }:
    {
      catppuccin.nvim.enable = false;

      home.sessionVariables = {
        JDTLS_JVM_ARGS = "-javaagent:" + Lombok + "/share/java/lombok.jar";
      };

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
          svelte-language-server
          tailwindcss-language-server
          vtsls

          # jvm langs
          jdt-language-server
          Lombok
          metals

          # HTML/CSS/JSON
          vscode-langservers-extracted

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
        ];
      };

      home.packages = [
        (pkgs.writeShellScriptBin "simplenvim" ''
          env NVIM_SIMPLE_MODE=1 ${neovimCmd} "$@"
        '')
      ];

      home.shellAliases = {
        v = "nvim";
      };

      home.sessionVariables = {
        EDITOR = "simplenvim";
      };

      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim-config";
    };
}
