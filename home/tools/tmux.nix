{ pkgs, ... }:

let
  shell = pkgs.lib.getExe pkgs.zsh;
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    clock24 = true;
    mouse = false;
    keyMode = "vi";
    shortcut = "t";
    inherit shell;
    extraConfig = builtins.readFile ../../dotfiles/tmux.conf + ''
      set -g default-command "${shell}"
    '';
  };

  catppuccin.tmux.extraConfig = builtins.readFile ../../dotfiles/tmux.conf.catppuccin;
}
