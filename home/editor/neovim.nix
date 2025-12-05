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
      stylua
      luaPackages.luacheck
      nixd
      pyright
      typos-lsp
      ruff
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
