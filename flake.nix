{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
    wallpapers = {
      url = "github:dharmx/walls";
      flake = false;
    };
    vars-file = {
      url = "file+file:///dev/null";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      vars =
        if builtins.readFile inputs.vars-file.outPath == "" then
          { gitIncludes = [ ]; }
        else
          import inputs.vars-file.outPath;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = [
        (inputs.import-tree ./modules)
        (inputs.import-tree ./profiles)
        (inputs.import-tree.filterNot (inputs.nixpkgs.lib.hasSuffix "hardware-configuration.nix") ./hosts)
      ];
      _module.args.vars = vars;
    };
}
