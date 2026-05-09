{
  pkgs,
  mkModule,
  vars,
  ...
}:

mkModule {
  name = "tool.git.basic";
  inheritModule = "tool.git";
  homeModule = {
    programs.git = {
      enable = true;

      settings = {
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        push.default = "current";
      };

      includes = vars.gitIncludes;
    };

    home.packages = with pkgs; [
      gh
      git-filter-repo
    ];

    home.shellAliases = {
      g = "git";
      gb = "git branch";
      gbd = "git branch -d";
      gcm = "git commit -m";
      gc = "git switch";
      gcb = "git switch -c";
      gl = "git log --oneline --graph --decorate";
    };
  };
}
