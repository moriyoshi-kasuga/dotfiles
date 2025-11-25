{ pkgs, ... }:

{
  home.packages = with pkgs; [
    delta
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      hyperlinks = true;
      side-by-side = true;
      line-numbers = true;
      navigate = true;
    };
  };
}
