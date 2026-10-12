{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.pc
      nixos.amd
      nixos.claude-desktop
      nixos.game
      ./_hardware-configuration.nix
      {
        people.primaryUser = "mori";
        networking.hostName = "Mori-NixOS";

        # The swap partition and resumeDevice (hardware configuration) make
        # hibernation possible here.
        services.logind.settings.Login.HandlePowerKey = "hibernate";

        # Monitors and the iGPU guard; included after the shared niri config.
        desktop.niri.extraConfig = builtins.readFile ./niri.kdl;

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

        # The USB condenser mic is the input here, so the earbuds should stay
        # on A2DP. By default WirePlumber flips them to the low-quality HFP
        # profile whenever any app opens their mic, and Proton games open a
        # test stream on every capture device at startup.
        services.pipewire.wireplumber.extraConfig."51-bluetooth-no-autoswitch"."wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };

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
