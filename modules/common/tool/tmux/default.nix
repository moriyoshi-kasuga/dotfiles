_:

{
  flake.modules.homeManager."tool.tmux" =
    { pkgs, ... }:
    let
      shell = pkgs.lib.getExe pkgs.fish;
    in
    {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        escapeTime = 0;
        clock24 = true;
        mouse = true;
        keyMode = "vi";
        shortcut = "t";
        inherit shell;
        extraConfig = builtins.readFile ./tmux.conf + ''
          set -g default-command "${shell}"
        '';
      };

      catppuccin.tmux.extraConfig = builtins.readFile ./tmux.conf.catppuccin;

      home.file.".config/tmux/new-session.fish" = {
        source = ./new-session.fish;
        executable = true;
      };
    };
}
