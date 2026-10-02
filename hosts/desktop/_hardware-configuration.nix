{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  # RDNA4 (RX 9060 XT) の amdgpu 修正を早く取り込むため最新カーネルを追う
  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "uas"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    # Ryzen 9700X: AMD P-State EPP (hardware-guided frequency scaling)
    "amd_pstate=active"
    # Avoid deep PCIe ASPM states, which cause link drops/stalls on the
    # onboard RTL8125B (r8169) NIC.
    "pcie_aspm.policy=performance"
  ];

  # Hibernate via swap partition
  boot.resumeDevice = "/dev/disk/by-uuid/1c6b591b-7f35-4527-b72a-0924593a1af5";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c28253ad-8343-4e40-8f7c-d4b193148cdb";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
      "noatime"
      "space_cache=v2"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/c28253ad-8343-4e40-8f7c-d4b193148cdb";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd:1"
      "noatime"
      "space_cache=v2"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/c28253ad-8343-4e40-8f7c-d4b193148cdb";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd:1"
      "noatime"
      "space_cache=v2"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D193-3BFB";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # 同じデバイス上のサブボリュームは 1 回の scrub でまとめて検査される
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1c6b591b-7f35-4527-b72a-0924593a1af5"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
