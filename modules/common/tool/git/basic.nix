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
    ];

    home.shellAliases = {
      g = "git";
      gb = "git branch";
      gbd = "git branch -d";
      gcm = "git commit -m";
      gc = "git checkout";
      gcb = "git checkout -b";
      gl = "git log --oneline --graph --decorate";
    };
  };
}
