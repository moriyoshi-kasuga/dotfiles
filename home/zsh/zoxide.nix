{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    _ZO_EXCLUDE_DIRS = "$HOME:/tmp/*:/var/*:/nix/*:/mnt/*";
  };

  programs.zsh.initContent = ''
    _run-cdi() {
      zi
      zle reset-prompt 
    }

    zle -N _run-cdi
    bindkey "^G" _run-cdi
  '';
}
