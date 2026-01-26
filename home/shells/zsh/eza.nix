{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eza
  ];

  programs.zsh.shellAliases = {
    l = "eza";
    ll = "eza --long --git";
    la = "eza --all";
    lsa = "eza --all --long";
    lt = "eza --tree --git-ignore";
  };
}
