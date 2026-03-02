{
  mkModule,
  ...
}:

mkModule {
  name = "tool.git.lazygit";
  inheritModule = "tool.git";
  homeModule = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showCommandLog = false;
          showIcons = false;
          mainPanelSplitMode = "vertical";
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
  };
}
