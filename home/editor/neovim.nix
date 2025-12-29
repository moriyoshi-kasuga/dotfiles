{
  pkgs,
  ...
}:

let
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  neovim = pkgs.neovim-unwrapped;
  neovimCmd = pkgs.lib.getExe neovim;
in
{
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
    ];
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "simplenvim" ''
      NVIM_SIMPLE_MODE=1 exec ${neovimCmd} "$@"
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

    # jvm langs
    jdt-language-server
    metals

    # HTML/CSS/JSON
    vscode-langservers-extracted

    # single package for each lang
    nixd
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
