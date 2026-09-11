_:

{
  flake.modules.nixos."gui.bluetooth" = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # `Enable` was removed from bluez's [General] section (those
      # profiles are on by default now); setting it just spams
      # "Unknown key Enable for group General" on every boot.
      settings.General = {
        Experimental = true;
      };
    };
  };
}
