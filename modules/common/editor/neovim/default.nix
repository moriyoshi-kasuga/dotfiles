{
  pkgs,
  mkModule,
  homeDirectory,
  ...
}:

let
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
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

      programs.neovim = {
        enable = true;
        package = neovim;

        extraWrapperArgs = [
          "--set"
          "TREESITTER_GRAMMARS"
          "${treesitterGrammars}"
        ];

        extraPackages = with pkgs; [
          treesitterGrammars

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

          # single package for each lang
          nixd
          nixfmt
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
