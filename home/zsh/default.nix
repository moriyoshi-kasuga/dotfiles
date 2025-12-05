{
  pkgs,
  dotfilesPath,
  vars,
  config,
  ...
}:

let
  zshConfigBefore = pkgs.lib.mkOrder 500 ''
    # Skip expensive operations for non-interactive shells
    if [[ $- != *i* ]]; then
      return
    fi
    
    unset __HM_SESS_VARS_SOURCED
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';
  zshConfigDefault = pkgs.lib.mkOrder 1000 (builtins.readFile (dotfilesPath + "/.zshrc"));
  zshConfigAfter = pkgs.lib.mkOrder 1500 ''
    if [[ -f $HOME/.local.zshrc ]]; then
      source $HOME/.local.zshrc
    fi
    
    # Defer autosuggestions
    zsh-defer source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    
    # Optimize compinit with cache
    autoload -Uz compinit
    if [[ -n ''${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
      zsh-defer compinit
    else
      zsh-defer compinit -C
    fi
    
    # Defer heavy plugins
    zsh-defer source ${vars.homeDirectory}/.zsh-scripts/mod.zsh
    
    # Defer syntax highlighting to reduce startup time
    zsh-defer source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    if [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
      source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
  '';
in
{

  home.packages = with pkgs; [
    # Download and use latest version
    bash
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    # Defer autosuggestions too
    autosuggestion.enable = false;
    # Disable syntax highlighting here - we'll load it deferred
    syntaxHighlighting.enable = false;
    defaultKeymap = "emacs";

    history = {
      save = 10000;
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
    };

    plugins = [
      {
        name = "zsh-defer";
        src = pkgs.zsh-defer.src;
      }
    ];

    initContent = pkgs.lib.mkMerge [
      zshConfigBefore
      zshConfigDefault
      zshConfigAfter
    ];

    shellAliases = {
      ".." = "cd ../";
      "..." = "cd ../../";

      e = "exit";
      reload = "exec zsh";
      todo = "vim ~/todo.md";
      mypaste = "rpaste --server ${vars.rustypasteServer or ""}";
    };
  };

  home.file.".zsh-scripts".source = dotfilesPath + "/zsh-scripts";

  imports = [
    ./starship.nix
    ./fzf.nix
    ./eza.nix
    ./zoxide.nix
    ./direnv.nix
    ./ai.nix
  ];
}
