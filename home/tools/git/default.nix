{ gitIncludes, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      push.default = "current";
    };

    includes = gitIncludes;
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

  imports = [
    ./lazygit.nix
    ./delta.nix
  ];
}
