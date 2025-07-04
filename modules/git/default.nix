{ vars, ... }:

{
  programs.git = {
    enable = true;
    userName = vars.gitUserName;
    userEmail = vars.gitUserEmail;

    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      push.default = "current";
    };
  };

  programs.zsh.shellAliases = {
    g = "git";
    gb = "git branch";
    gbd = "git branch -d";
    gcm = "git commit -m";
    gc = "git checkout";
    gcb = "git checkout -b";
    gl = "git log --oneline --graph --decorate";
    glg = "git log --pretty=format:'%C(yellow)%h%Creset %C(green)(%ad)%Creset %C(blue)%d%Creset %s %C(red)(%an)%Creset' --date=iso --graph";
  };

  imports = [
    ./lazygit.nix
    ./delta.nix
  ];
}
