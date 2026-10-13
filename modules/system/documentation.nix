_:

{
  flake.modules.nixos.base = {
    documentation.enable = false;
    # programs.fish が有効にする man page の cache を作らない
    documentation.man.cache.enable = false;

    programs.command-not-found.enable = false;
  };
}
