{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showCommandLog = false;
        showIcons = false;
        mainPanelSplitMode = "vertical";
      };
      os = {
        editPreset = "vim";
      };
    };
  };
}
