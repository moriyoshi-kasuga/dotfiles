_:

{
  # ログインシェルは fish。zsh は system 側で有効にするだけで、home-manager では管理しない。
  flake.modules.nixos.base = {
    programs.zsh.enable = true;
  };

  flake.modules.darwin.base = {
    programs.zsh.enable = true;
  };
}
