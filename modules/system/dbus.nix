_:

{
  flake.modules.nixos.base = {
    services.dbus.enable = true;
  };
}
