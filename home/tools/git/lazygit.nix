{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showCommandLog = false;
        showIcons = false;
        mainPanelSplitMode = "vertical";
      };
      os = {
        editPreset = "simplenvim";
      };
      git = {
        pagers = [
          {
            pager = "delta --dark --paging=never --diff-so-fancy";
          }
        ];
      };
    };
  };
}
