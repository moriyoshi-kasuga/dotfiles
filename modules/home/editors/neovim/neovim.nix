{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  program = "neovim";
  cfg = config.modules."${program}";

  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  neovim = pkgs.neovim-unwrapped;
  neovimCmd = pkgs.lib.getExe neovim;
in
{
  options.modules."${program}" = {
    enable = mkEnableOption program;
  };
  config = mkIf cfg.enable {
    catppuccin.nvim.enable = false;

    programs.neovim = {
      enable = true;
      package = neovim;

      extraWrapperArgs = [
        "--set"
        "TREESITTER_GRAMMARS"
        "${treesitterGrammars}"
      ];

      extraPackages = [
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
        metals

        # HTML/CSS/JSON
        vscode-langservers-extracted

        # single package for each lang
        nixd
        fsautocomplete
        just-lsp
        hadolint
        actionlint
        gopls
        typos-lsp
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

    xdg.configFile."nvim".source = ./config;
  };
}
