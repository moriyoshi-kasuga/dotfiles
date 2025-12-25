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

    # jvm
    jdt-language-server
    metals

    # single package for each lang
    nixd
    fsautocomplete

    # HTML/CSS/JSON/ESLint
    vscode-langservers-extracted

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
