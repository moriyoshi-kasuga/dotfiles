{
  pkgs,
  dotfilesPath,
  vars,
  config,
  ...
}:

let
  zshConfigDefault = pkgs.lib.mkOrder 1000 (builtins.readFile (dotfilesPath + /.zshrc));
  zshConfigAfter = pkgs.lib.mkOrder 1500 ''
    autoload -Uz compinit && zsh-defer compinit
    zsh-defer source ${vars.homeDirectory}/.zsh-scripts/mod.zsh
  '';
in
{
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
  ];

  home.file.".zprofile".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';
}
