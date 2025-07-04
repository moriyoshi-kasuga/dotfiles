{ pkgs, ... }:

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
    shortcut = "C-t";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
