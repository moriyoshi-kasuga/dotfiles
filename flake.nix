{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    vars-file = {
      url = "file+file:///dev/null";
      flake = false;
    };
    nix-claude-code = {
      url = "github:ryoppippi/nix-claude-code";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      mkPlatform = import ./lib/mkPlatform.nix;
    in
    mkPlatform [
      {
        name = "desktop";
        inherit inputs;
        system = "x86_64-linux";
        host = "nixos";
        username = "mori";
        homeDirectory = "/home/mori";
        modules = {
          modules.base.enable = true;
          modules.nixos = {
            enable = true;
            gui.enable = true;
            gui.amd.enable = true;
            network.hostName = "Mori-NixOS";
          };

          modules.shell = {
            enable = true;
            fish.default = true;
          };
          modules.lang.enable = true;
          modules.editor.enable = true;
          modules.tool = {
            enable = true;
            git.enable = true;
            claude-code.enable = true;
          };
          modules.terminal.wezterm.enable = true;
          modules.library.enable = true;
          modules.font.enable = true;
          modules.wallpaper = {
            enable = true;
            owner = "dharmx";
            repo = "walls";
          };
        };
        homeConfig = {
          imports = [ inputs.noctalia.homeModules.default ];
        };
        nixosConfig = {
          imports = [
            ./hosts/desktop/hardware-configuration.nix
          ];
        };
      }
      {
        name = "laptop-nixos";
        inherit inputs;
        system = "x86_64-linux";
        host = "nixos";
        username = "mori";
        homeDirectory = "/home/mori";
        modules = {
          modules.base.enable = true;
          modules.nixos = {
            enable = true;
            gui.enable = true;
            gui.nvidia.enable = true;
            network.hostName = "Mori-Laptop-NixOS";
          };

          modules.shell = {
            enable = true;
            fish.default = true;
          };
          modules.lang.enable = true;
          modules.editor.enable = true;
          modules.tool = {
            enable = true;
            git.enable = true;
            claude-code.enable = true;
          };
          modules.terminal.wezterm.enable = true;
          modules.library.enable = true;
          modules.font.enable = true;
          modules.wallpaper = {
            enable = true;
            owner = "dharmx";
            repo = "walls";
          };
        };
        homeConfig = {
          imports = [ inputs.noctalia.homeModules.default ];
        };
        nixosConfig = {
          imports = [
            ./hosts/laptop-nixos/hardware-configuration.nix
          ];
        };
      }
      {
        name = "sv-main";
        inherit inputs;
        system = "x86_64-linux";
        host = "nixos";
        username = "sv-main";
        homeDirectory = "/home/sv-main";
        modules = {
          modules.base.enable = true;
          modules.nixos = {
            enable = true;
            network.hostName = "sv-main";
          };
          modules.shell = {
            enable = true;
            fish.default = true;
          };
          modules.lang = {
            c.enable = true;
          };
          modules.editor.enable = true;
          modules.tool = {
            enable = true;
            git.enable = true;
          };
        };
        homeConfig = {
          imports = [ inputs.noctalia.homeModules.default ];
        };
        nixosConfig = {
          imports = [
            ./hosts/sv-main/hardware-configuration.nix
          ];
        };
      }
      {
        name = "laptop-mac";
        inherit inputs;
        system = "aarch64-darwin";
        host = "darwin";
        username = "mori";
        homeDirectory = "/Users/mori";
        modules = {
          modules.base.enable = true;
          modules.darwin = {
            enable = true;
            tailscale.enable = true;
          };

          modules.shell = {
            enable = true;
            fish.default = true;
          };
          modules.lang.enable = true;
          modules.editor.enable = true;
          modules.tool = {
            enable = true;
            git.enable = true;
            claude-code.enable = true;
          };
          modules.terminal.wezterm.enable = true;
          modules.library.enable = true;
          modules.font.enable = true;
          modules.wallpaper = {
            enable = true;
            owner = "dharmx";
            repo = "walls";
          };
        };
      }
      {
        name = "job";
        inherit inputs;
        system = "aarch64-darwin";
        host = "darwin";
        username = "mori";
        homeDirectory = "/Users/mori";
        modules = {
          modules.base.enable = true;
          modules.darwin.enable = true;

          modules.shell = {
            enable = true;
            fish.default = true;
          };
          modules.lang.enable = true;
          modules.editor.enable = true;
          modules.tool = {
            enable = true;
            git.enable = true;
            claude-code.enable = true;
          };
          modules.terminal.wezterm = {
            enable = true;
            bigMonitor = true;
          };
          modules.library.enable = true;
          modules.font.enable = true;
          modules.wallpaper = {
            enable = true;
            owner = "dharmx";
            repo = "walls";
          };
        };
      }
    ];
}
