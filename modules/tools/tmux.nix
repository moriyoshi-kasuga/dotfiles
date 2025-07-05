{ pkgs, dotfilesPath, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    clock24 = true;
    keyMode = "vi";
    shortcut = "t";
    extraConfig = builtins.readFile (dotfilesPath + /tmux.conf);
  };

  catppuccin.tmux.extraConfig = builtins.readFile (dotfilesPath + /tmux.conf.catppuccin);
}
