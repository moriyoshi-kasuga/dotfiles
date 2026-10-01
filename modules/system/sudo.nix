_:

{
  flake.modules.nixos.base = {
    security = {
      sudo.execWheelOnly = true;
      sudo.keepTerminfo = true;
    };
  };
}
