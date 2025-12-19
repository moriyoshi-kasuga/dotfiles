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
    (pkgs.writeShellScriptBin "simplenvim" ''
      NVIM_SIMPLE_MODE=1 exec ${pkgs.neovim}/bin/nvim "$@"
    '')

    bash-language-server
    shellcheck
    shfmt

    # HTML/CSS/JSON/ESLint
    vscode-langservers-extracted

    lua-language-server
    stylua

    nixd

    ty
    ruff

    svelte-language-server
    tailwindcss-language-server
    vtsls

    fsautocomplete

    just-lsp
    tombi
    hadolint
    actionlint
    typos-lsp
  ];

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
