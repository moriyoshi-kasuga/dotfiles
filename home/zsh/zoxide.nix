{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zoxide
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    _ZO_EXCLUDE_DIRS = "$HOME:/tmp/*:/var/*:/nix/*:/mnt/*";
    _ZO_FZF_OPTS = "--style minimal --tmux 75%,85%";
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
