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
      rev = "40225f6488d7eaf5c9545e61a17164a4115210a5";
      sha256 = "5lXVAaGYmaHKtW6PKjCCyW+qnMkQHCSh4VVny56OxkQ=";
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
      builtins.readFile (dotfilesPath + "/.vimrc")
      + ''
        let g:lightline = {'colorscheme': 'catppuccin_${vars.catppuccinFlavor}'}
        colorscheme catppuccin_${vars.catppuccinFlavor}
      '';
  };
}
