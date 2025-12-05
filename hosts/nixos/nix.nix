{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow dynamic linking for NixOS
  programs.nix-ld.enable = true;

  nix = {
    # Enable Nix flakes and nix command line tool
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Optimize Nix store and perform garbage collection automatically
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
