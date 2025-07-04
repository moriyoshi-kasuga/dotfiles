{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
  ];

  programs.fzf.enableZshIntegration = true;
}
