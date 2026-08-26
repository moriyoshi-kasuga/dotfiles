_:

{
  flake.modules.homeManager."tool.git.delta" = {
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
