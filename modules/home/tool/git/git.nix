{
  mkModule,
  ...
}:

mkModule {
  name = "git";
  module = {
    programs.git = {
      enable = true;

      settings = {
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        push.default = "current";
      };

      includes = {
        user.email = "moriyoshi.kasuga1218@gmail.com";
        user.name = "moriyoshi-kasuga";
      };
    };

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
