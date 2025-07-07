{ pkgs, dotfilesPath, ... }:

let
  shell = "${pkgs.zsh}/bin/zsh";
in
{
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    clock24 = true;
    mouse = false;
    keyMode = "vi";
    shortcut = "t";
    shell = shell;
    extraConfig =
      builtins.readFile (dotfilesPath + /tmux.conf)
      + ''
        set -g default-command "${shell}"
      '';
  };

  catppuccin.tmux.extraConfig = builtins.readFile (dotfilesPath + /tmux.conf.catppuccin);
}
