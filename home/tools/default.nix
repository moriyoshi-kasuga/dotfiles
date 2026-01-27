{ pkgs, ... }:

{
  imports = [
    ./tmux
    ./docker.nix
    ./tff.nix
    ./git
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    jq
    jid
    tailspin
    xh
    dust
    duf
    git-cliff
    kind
    kubernetes-helm
    tldr
    gh
    gh-dash
    google-java-format
    zip
    unzip
    lnav
    glow
    bottom
    just
    tailspin
  ];

  programs = {
    yazi.enable = true;
    fd.enable = true;
    bat.enable = true;
    jq.enable = true;
    lazydocker.enable = true;
  };

  home.shellAliases = {
    fdh = "fd -H -E \".git\"";
  };

  xdg.configFile."opencode/opencode.json".source = ./opencode/opencode.json;
}
