{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    direnv
  ];

  programs.zsh.initContent = ''
    eval "$(direnv hook zsh)"
  '';
}
