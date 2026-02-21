{
  mkModule,
  pkgs,
  defaultShell,
  ...
}:

let
  shell = pkgs.lib.getExe defaultShell;
in
mkModule {
  name = "tmux";
  module = {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      clock24 = true;
      mouse = false;
      keyMode = "vi";
      shortcut = "t";
      inherit shell;
      extraConfig = builtins.readFile ./tmux.conf + ''
        set -g default-command "${shell}"
      '';
    };

    catppuccin.tmux.extraConfig = builtins.readFile ./tmux.conf.catppuccin;
  };
}
