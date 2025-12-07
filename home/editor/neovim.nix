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
    bash-language-server
    shellcheck
    shfmt

    lua-language-server
    stylua

    nixd

    pyright
    ruff

    svelte-language-server
    tailwindcss-language-server
    vtsls

    hadolint
    actionlint
    typos-lsp
  ];

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
