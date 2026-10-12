{
  description = "NixOS / nix-darwin configurations with home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-palette = {
      url = "github:catppuccin/palette";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-claude-code = {
      url = "github:ryoppippi/nix-claude-code";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    leonardomso-rust-skills = {
      url = "github:leonardomso/rust-skills";
      flake = false;
    };
    obra-superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };
    Egonex-AI-Understand-Anything = {
      url = "github:Egonex-AI/Understand-Anything";
      flake = false;
    };
    wallpapers = {
      url = "github:dharmx/walls";
      flake = false;
    };
  };

  outputs =
    inputs:
    # `modules` is only consumed internally via `config.flake.modules`, and
    # `nix flake check` warns about it as an unknown output, so drop it here.
    removeAttrs (inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = [
        (inputs.import-tree ./modules)
        (inputs.import-tree ./hosts)
      ];
    }) [ "modules" ];
}
