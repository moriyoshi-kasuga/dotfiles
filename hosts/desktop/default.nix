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
      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          people.primaryUser = "mori";
          people.flakeHost = "desktop";
          networking.hostName = "Mori-NixOS";

          # Hibernate to the swap partition from the hardware configuration.
          boot.resumeDevice = (lib.head config.swapDevices).device;
          services.logind.settings.Login.HandlePowerKey = "hibernate";

          # RDNA4 (RX 9060 XT) の amdgpu 修正を早く取り込むため最新カーネルを追う
          boot.kernelPackages = pkgs.linuxPackages_latest;

          boot.kernelParams = [
            # Ryzen 9700X: AMD P-State EPP (hardware-guided frequency scaling)
            "amd_pstate=active"
            # Avoid deep PCIe ASPM states, which cause link drops/stalls on the
            # onboard RTL8125B (r8169) NIC.
            "pcie_aspm.policy=performance"
            # This Zen 5 chip's bus-lock detection fires constantly under
            # Chrome/Proton (tens of thousands of trapped+throttled
            # instructions per minute per journalctl), tanking their
            # performance for a mitigation that mainly matters on
            # multi-tenant hosts, not a single-user desktop.
            "split_lock_detect=off"
          ];

          # 既定 (max-jobs = CPU 数, cores = 0 は全コア) だと 16 並列 x 16 スレッドまで膨らみ、
          # メモリを使い切ってデスクトップごと固まる
          nix.settings = {
            max-jobs = 4;
            cores = 8;
          };

          # 同じデバイス上のサブボリュームは 1 回の scrub でまとめて検査される
          services.btrfs.autoScrub = {
            enable = true;
            fileSystems = [ "/" ];
          };

          # btrfs は discard=async で解放した領域を随時 TRIM するので、週 1 回の fstrim は
          # 空き領域全体 (1 TiB 超) を毎回 TRIM し直すだけで 5 から 11 分かかる
          services.fstrim.enable = false;

          # The MT7922's Bluetooth half sits on USB via btusb, which
          # autosuspends it when idle. Power saving is irrelevant on a desktop,
          # so keep it awake to rule it out when audio misbehaves. It caused
          # neither known symptom: the "ACL packet for unknown connection
          # handle 3837" kernel errors come from the MT7922 firmware (often
          # exactly 60s apart while a device is connected), and the earbud
          # dropouts were a weak link until the board's Wi-Fi antennas, which
          # Bluetooth shares, were attached.
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

          # Monitors and the iGPU guard; included after the shared niri config.
          desktop.niri.extraConfig = builtins.readFile ./niri.kdl;

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
      )
    ];
  };
}
