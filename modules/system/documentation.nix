_:

{
  flake.modules.nixos.base = {
    documentation.enable = false;
    documentation.man.cache.enable = false;

    programs.command-not-found.enable = false;
  };
}
