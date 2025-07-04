{ pkgs, ... }:
{
  home.packages = with pkgs; [
    delta
  ];

  programs.git = {
    delta = {
      enable = true;
      options = {
        hyperlinks = true;
        side-by-side = true;
        line-numbers = true;
        navigate = true;
      };
    };
  };
}
