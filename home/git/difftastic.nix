{ pkgs, ... }:

{
  home.packages = with pkgs; [
    difftastic
  ];

  programs.difftastic = {
    enable = true;
    git.enable = true;
    git.diffToolMode = true;
  };
}
