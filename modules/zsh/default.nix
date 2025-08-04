{
  pkgs,
  dotfilesPath,
  vars,
  config,
  ...
}:

let
  zshConfigBefore = pkgs.lib.mkOrder 500 ''
    unset __HM_SESS_VARS_SOURCED
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';
  zshConfigDefault = pkgs.lib.mkOrder 1000 (builtins.readFile (dotfilesPath + /.zshrc));
  zshConfigAfter = pkgs.lib.mkOrder 1500 ''
    if [[ -f $HOME/.local.zshrc ]]; then
      source $HOME/.local.zshrc
    fi
    autoload -Uz compinit && zsh-defer compinit
    zsh-defer source ${vars.homeDirectory}/.zsh-scripts/mod.zsh
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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    history = {
      save = 10000;
      size = 10000;
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
    };
  };

  home.file.".zsh-scripts".source = dotfilesPath + /zsh-scripts;

  imports = [
    ./starship.nix
    ./fzf.nix
    ./eza.nix
    ./zoxide.nix
    ./direnv.nix
    ./ai.nix
  ];
}
