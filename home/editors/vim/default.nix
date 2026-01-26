{
  pkgs,
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
      BetterEscape
      editorconfig-vim
      catppuccin-vim
      quick-scope
      vim-surround
      vim-commentary
      fzf-vim
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}