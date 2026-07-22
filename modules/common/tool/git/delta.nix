{
  mkModule,
  ...
}:

mkModule {
  name = "tool.git.delta";
  inheritModule = "tool.git";
  homeModule = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        line-numbers-left-format = "";
        line-numbers-right-format = "{np:^4}│ ";
        diff-so-fancy = true;
        line-numbers = true;
        navigate = true;
      };
    };
  };
}
