_:

{
  # ログインシェルは fish。zsh は system 側で有効にするだけで、home-manager では管理しない。
  # nix-darwin では programs.zsh.enable が既定で true。
  flake.modules.nixos.base = {
    programs.zsh.enable = true;
  };
}
