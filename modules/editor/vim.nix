{
  pkgs,
  vars,
  dotfilesPath,
  ...
}:

let
  BetterEscape = pkgs.vimUtils.buildVimPlugin {
    name = "better-escape";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-zh";
      repo = "better-escape.vim";
      rev = "6b16a45a839727977277f6ab11bded63e9ed86bb";
      sha256 = "usuUic5k/rsKccTjEBG105kTM/wiJmmPatlmIMlNtlE=";
    };
  };
in
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-commentary
      vim-easyescape
      lightline-vim
      catppuccin-vim
      editorconfig-vim
      undotree
      quick-scope
      fzf-vim
      BetterEscape
    ];
    extraConfig =
      builtins.readFile (dotfilesPath + /.vimrc)
      + ''
        let g:lightline = {'colorscheme': 'catppuccin_${vars.catppuccinFlavor}'}
        colorscheme catppuccin_${vars.catppuccinFlavor}
      '';
  };
}
