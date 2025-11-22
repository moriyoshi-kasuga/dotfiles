{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow dynamic linking for NixOS
  programs.nix-ld.enable = true;

  # Enable Nix flakes and nix command line tool
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Optimize Nix store and perform garbage collection automatically
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
