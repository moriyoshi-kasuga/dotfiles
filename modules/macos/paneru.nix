{ inputs, ... }:

{
  flake.modules.darwin.paneru = { ... }: {
    imports = [ inputs.paneru.darwinModules.paneru ];

    services.paneru = {
      enable = true;
      settings = {
        options = {
          # niri と同じく、focus と mouse を連動させない
          focus_follows_mouse = false;
          mouse_follows_focus = false;

          # niri の preset-column-widths / preset-window-heights と揃える
          preset_column_widths = [
            0.33333
            0.5
            0.66667
            1.0
          ];
          preset_stack_heights = [
            0.33333
            0.5
            0.66667
            1.0
          ];

          # niri の dynamic workspace のように、下に移ると作り、空になると消す
          create_virtual_workspace_automatically = true;
          reap_empty_workspaces = true;
        };

        # niri の default-column-width と揃える
        windows.default = {
          title = ".*";
          width = 0.5;
        };

        bindings = {
          # Focus (niri: Alt+H/J/K/L)
          # j/k は stack 内に移る先がなければ、その方向の display に移る
          window_focus_west = "cmd - h";
          window_focus_south = "cmd - j";
          window_focus_north = "cmd - k";
          window_focus_east = "cmd - l";

          # Move window (niri: Alt+Ctrl+H/J/K/L)
          window_swap_west = "cmd + ctrl - h";
          window_swap_south = "cmd + ctrl - j";
          window_swap_north = "cmd + ctrl - k";
          window_swap_east = "cmd + ctrl - l";

          # Move to monitor (niri: Alt+Shift+Ctrl+H/J/K/L)
          # paneru は方向を指定できず次の display に送るだけなので、全方向を同じにする
          window_nextdisplay = [
            "cmd + shift + ctrl - h"
            "cmd + shift + ctrl - j"
            "cmd + shift + ctrl - k"
            "cmd + shift + ctrl - l"
          ];

          # Workspace navigation (niri: Alt+U/I)
          window_virtual_south = "cmd - u";
          window_virtual_north = "cmd - i";

          # Move to adjacent workspace (niri: Alt+Ctrl+U/I)
          window_virtualmove_south = "cmd + ctrl - u";
          window_virtualmove_north = "cmd + ctrl - i";

          # Stack (niri: Alt+Comma/Period)
          window_stack = "cmd - comma";
          window_unstack = "cmd - period";

          # Full width (niri: Alt+F)
          window_fullwidth = "cmd + shift - f";

          # Switch floating and tiling (niri: Alt+V)
          window_manage = "cmd + shift - v";

          # 以下は cmd だと macOS 標準のショートカット (reload, copy, zoom) と衝突するので alt にする

          # Resize (niri: Alt+R, Alt+Shift+R, Alt+Ctrl+R)
          window_resize = "alt - r";
          window_vertical_resize = "alt + shift - r";
          window_equalize = "alt + ctrl - r";

          # Center (niri: Alt+C)
          window_center = "alt - c";

          # Width / height (niri: Alt+Minus/Equal, Alt+Shift+Minus/Equal)
          window_shrink = "alt - minus";
          window_grow = "alt - equal";
          window_vertical_shrink = "alt + shift - minus";
          window_vertical_grow = "alt + shift - equal";
        };
      };
    };
  };
}
