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
      # https://github.com/yukimura1227/vim-yazi/pull/1
      # owner = "yukimura1227";
      owner = "moriyoshi-kasuga";
      repo = "vim-yazi";
      rev = "27c3a4b8b5fb7cf23026a459db478e1529cef03e";
      sha256 = "UZEuz5YOmAOhuSLExM0akWop5HKPS9YESCSkVOt5w30=";
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
