{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showCommandLog = false;
        showIcons = false;
        mainPanelSplitMode = "vertical";
      };
      git = {
        localBranchSortOrder = "recency";

        diffRenderers = [
          {
            command = "delta --dark --paging=never --diff-so-fancy";
          }
        ];
      };
    };
  };
}
