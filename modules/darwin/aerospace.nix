{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.aerospace";
  inheritModule = "darwin";
  darwinModule = {
    services.aerospace = {
      enable = true;
      settings = {
        on-focused-monitor-changed = [ ];
        gaps = {
          inner = {
            horizontal = 0;
            vertical = 0;
          };
          outer = {
            left = 0;
            bottom = 0;
            top = 0;
            right = 0;
          };
        };
        mode = {
          main = {
            binding = {
              # Focus (niri: Alt+H/J/K/L)
              cmd-h = "focus left";
              cmd-l = "focus right";
              cmd-j = "focus down";
              cmd-k = "focus up";

              # Move window (niri: Alt+Ctrl+H/J/K/L)
              cmd-ctrl-h = "move left";
              cmd-ctrl-l = "move right";
              cmd-ctrl-j = "move down";
              cmd-ctrl-k = "move up";

              # Focus monitor (niri: Alt+Shift+H/J/K/L)
              cmd-shift-h = "focus-monitor left";
              cmd-shift-l = "focus-monitor right";
              cmd-shift-j = "focus-monitor down";
              cmd-shift-k = "focus-monitor up";

              # Move to monitor (niri: Alt+Shift+Ctrl+H/J/K/L)
              cmd-shift-ctrl-h = [
                "move-node-to-monitor left"
                "focus-monitor left"
              ];
              cmd-shift-ctrl-l = [
                "move-node-to-monitor right"
                "focus-monitor right"
              ];
              cmd-shift-ctrl-j = [
                "move-node-to-monitor down"
                "focus-monitor down"
              ];
              cmd-shift-ctrl-k = [
                "move-node-to-monitor up"
                "focus-monitor up"
              ];

              # Workspace navigation (niri: Alt+U/I)
              cmd-u = "workspace --wrap-around prev";
              cmd-i = "workspace --wrap-around next";

              # Move to adjacent workspace (niri: Alt+Ctrl+U/I)
              cmd-ctrl-u = [
                "move-node-to-workspace --wrap-around prev"
                "workspace --wrap-around prev"
              ];
              cmd-ctrl-i = [
                "move-node-to-workspace --wrap-around next"
                "workspace --wrap-around next"
              ];

              # Layout (niri: Alt+Slash / Alt+Comma)
              cmd-slash = "layout tiles horizontal vertical";
              cmd-comma = "layout accordion horizontal vertical";

              # Fullscreen (niri: Alt+F / Alt+Shift+F)
              cmd-f = "fullscreen";

              # Switch floating and tiling
              cmd-shift-space = "layout floating tiling";

              # Focus workspace (niri: Alt+1-9)
              cmd-1 = "workspace 1";
              cmd-2 = "workspace 2";
              cmd-3 = "workspace 3";
              cmd-4 = "workspace 4";
              cmd-5 = "workspace 5";
              cmd-6 = "workspace 6";
              cmd-7 = "workspace 7";
              cmd-8 = "workspace 8";
              cmd-9 = "workspace 9";

              # Move to workspace (niri: Alt+Ctrl+1-9)
              cmd-ctrl-1 = [
                "move-node-to-workspace 1"
                "workspace 1"
              ];
              cmd-ctrl-2 = [
                "move-node-to-workspace 2"
                "workspace 2"
              ];
              cmd-ctrl-3 = [
                "move-node-to-workspace 3"
                "workspace 3"
              ];
              cmd-ctrl-4 = [
                "move-node-to-workspace 4"
                "workspace 4"
              ];
              cmd-ctrl-5 = [
                "move-node-to-workspace 5"
                "workspace 5"
              ];
              cmd-ctrl-6 = [
                "move-node-to-workspace 6"
                "workspace 6"
              ];
              cmd-ctrl-7 = [
                "move-node-to-workspace 7"
                "workspace 7"
              ];
              cmd-ctrl-8 = [
                "move-node-to-workspace 8"
                "workspace 8"
              ];
              cmd-ctrl-9 = [
                "move-node-to-workspace 9"
                "workspace 9"
              ];
            };
          };
        };
        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "main";
          "3" = "main";
          "4" = "main";
          "5" = "main";
          "6" = [
            "secondary"
            "main"
          ];
          "7" = [
            "secondary"
            "main"
          ];
          "8" = [
            "secondary"
            "main"
          ];
          "9" = [
            "secondary"
            "main"
          ];
        };
      };
    };
  };
}
