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
        diff-so-fancy = true;
        line-numbers = true;
        navigate = true;
      };
    };
  };
}
