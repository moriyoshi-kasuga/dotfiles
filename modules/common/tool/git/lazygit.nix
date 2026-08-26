_:

{
  flake.modules.homeManager."tool.git.lazygit" = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showCommandLog = false;
          showIcons = false;
          mainPanelSplitMode = "vertical";
        };
        git = {
          diffRenderers = [
            {
              command = "delta --dark --paging=never --diff-so-fancy";
            }
          ];
        };
      };
    };
  };
}
