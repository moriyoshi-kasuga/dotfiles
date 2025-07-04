{ pkgs, ... }:

{
  home.packages = [
    pkgs.starship
  ];

  programs.zsh = {
    initContent = ''
      eval "$(starship init zsh)"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      package.disabled = true;

      java.disabled = true;
      kotlin.disabled = true;
      gradle.disabled = true;
      aws.disabled = true;
    };
  };
}
