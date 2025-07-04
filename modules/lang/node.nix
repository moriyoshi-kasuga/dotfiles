{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bun
  ];

  programs.bun = {
    enable = true;
  };
}
