{
  pkgs,
  config,
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

  programs.lazygit.settings.os.editPreset = "simplenvim";

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "simplenvim" ''
      env NVIM_SIMPLE_MODE=1 ${neovimCmd} "$@"
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
    hadolint
    actionlint
    gopls
    typos-lsp
    asm-lsp
    # tombiが新しいtoml lspとしてあるが、sortの無効化が保守的だったり、configが不完全のためtaploを使用する
    taplo
  ];

  home.shellAliases = {
    v = "nvim";
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/editors/neovim/config";
}
