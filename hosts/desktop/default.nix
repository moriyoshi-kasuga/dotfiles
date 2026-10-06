{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos.pc
      nixos.amd
      nixos.claude-desktop
      nixos.game
      ./_hardware-configuration.nix
      {
        people.primaryUser = "mori";
        networking.hostName = "Mori-NixOS";

        # RDNA4 dGPU (RX 9060 XT) is new hardware; keep firmware/microcode
        # blobs up to date to reduce amdgpu instability (fence timeouts).
        hardware.enableRedistributableFirmware = true;

        # This Zen 5 chip's bus-lock detection fires constantly under
        # Chrome/Proton (tens of thousands of trapped+throttled
        # instructions per minute per journalctl), tanking their
        # performance for a mitigation that mainly matters on
        # multi-tenant hosts, not a single-user desktop.
        boot.kernelParams = [ "split_lock_detect=off" ];

        # The MT7922's Bluetooth half sits on USB via btusb, which
        # autosuspends it when idle; resuming it mid-stream causes audio
        # dropouts and "ACL packet for unknown connection handle" errors.
        # Power saving is irrelevant on a desktop.
        boot.extraModprobeConfig = ''
          options btusb enable_autosuspend=0
        '';

        style.fonts.monospace = "monaspace-neon";

        people.home.imports = [
          home."lang.buf"
          home."lang.c"
          home."lang.go"
          home."lang.haskell"
          home."lang.jvm"
          home."lang.lua"
          home."lang.node"
          home."lang.python"
          home."lang.rust"
          home."lang.wasm"
        ];
      }
    ];
  };
}
