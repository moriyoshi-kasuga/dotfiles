{
  config,
  lib,
  vars,
  pkgs,
  ...
}:

let
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
in
{
  catppuccin.nvim.enable = false;

  home.activation.nvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn ${vars.dotfilesRepoDir}/dotfiles/neovim ${config.home.homeDirectory}/.config/nvim
  '';

  programs.neovim = {
    enable = true;

    extraWrapperArgs = [
      "--set"
      "TREESITTER_GRAMMARS"
      "${treesitterGrammars}"
    ];

    extraPackages = with pkgs; [
      treesitterGrammars

      lua-language-server
      nixd
      efm-langserver
      pyright
      typos-lsp
      ruff
      stylua
      hadolint
      actionlint
      svelte-language-server
      tailwindcss-language-server
      vtsls
    ];
  };

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
