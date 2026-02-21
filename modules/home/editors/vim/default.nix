{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "vim";
  module = {
    catppuccin.vim.enable = false;
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        editorconfig-vim
        catppuccin-vim
        quick-scope
        vim-surround
        vim-commentary
        fzf-vim
        (pkgs.vimUtils.buildVimPlugin {
          name = "better-escape";
          src = pkgs.fetchFromGitHub {
            owner = "nvim-zh";
            repo = "better-escape.vim";
            rev = "6b16a45a839727977277f6ab11bded63e9ed86bb";
            sha256 = "usuUic5k/rsKccTjEBG105kTM/wiJmmPatlmIMlNtlE=";
          };
        })
      ];
      extraConfig = builtins.readFile ./vimrc;
    };
  };
}
