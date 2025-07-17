{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
  ];

  programs.zsh.shellAliases = {
    lg = "lazygit";
  };

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
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
