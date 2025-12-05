{
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

    extraPackages = [
      treesitterGrammars
    ];
  };

  home.packages = with pkgs; [
    lua-language-server
    stylua
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

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
