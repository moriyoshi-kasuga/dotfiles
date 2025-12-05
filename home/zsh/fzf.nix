{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
  ];

  programs.fzf = {
    enable = true;
  };

  # Defer fzf-tab loading entirely to improve startup time
  programs.zsh.initContent = ''
    # Defer fzf-tab loading
    zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    
    # Configure fzf-tab (will be applied when loaded)
    zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border --ansi
  '';
}
