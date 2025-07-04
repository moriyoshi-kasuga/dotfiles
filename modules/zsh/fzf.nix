{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
  ];

  programs.fzf = {
    enable = true;
  };

  programs.zsh.initContent = ''
    eval "$(fzf --zsh)"
  '';

  programs.zsh.plugins = [
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab.src;
    }
  ];
}
