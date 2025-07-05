{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zoxide
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.zsh.initContent = ''
    _run-cdi() {
      cdi
      zle reset-prompt 
    }

    zle -N _run-cdi
    bindkey "^G" _run-cdi
  '';
}
