_:

{
  flake.modules.nixos.base = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;

      # This Zen 5 chip's bus-lock detection fires constantly under
      # Chrome/Proton (tens of thousands of trapped+throttled
      # instructions per minute per journalctl), tanking their
      # performance for a mitigation that mainly matters on
      # multi-tenant hosts, not a single-user desktop.
      kernelParams = [ "split_lock_detect=off" ];
    };
  };
}
