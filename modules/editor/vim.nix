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
  VimYazi = pkgs.vimUtils.buildVimPlugin {
    name = "vim-yazi";
    src = pkgs.fetchFromGitHub {
      owner = "moriyoshi-kasuga";
      repo = "vim-yazi";
      rev = "159119dbaef9232759e3b4546907c3831c6c2547";
      sha256 = "sha256-n37H3V68Rm21xxNJnzMty30vI+Vg/qWAttGXVn1xpL8=";
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
      VimYazi
    ];
    extraConfig =
      builtins.readFile (dotfilesPath + /.vimrc)
      + ''
        let g:lightline = {'colorscheme': 'catppuccin_${vars.catppuccinFlavor}'}
        colorscheme catppuccin_${vars.catppuccinFlavor}
      '';
  };
}
