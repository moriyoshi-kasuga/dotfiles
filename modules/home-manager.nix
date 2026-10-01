{ inputs, vars, ... }:

let
  inherit (inputs.self.modules) nixos darwin homeManager;

  homeManagerCommon = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit vars inputs; };
  };
in
{
  # 層の配線: base は全 host、pc は画面を持つ host。
  # OS 側の層を import すると、対応する home 側の層も primaryUser に入る。
  flake.modules.nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = homeManagerCommon // {
      backupFileExtension = "nixbackup";
    };
    people.home.imports = [ homeManager.base ];
  };
  flake.modules.darwin.base = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager = homeManagerCommon;
    people.home.imports = [ homeManager.base ];
  };

  flake.modules.nixos.pc = {
    imports = [ nixos.base ];
    people.home.imports = [ homeManager.pc ];
  };
  flake.modules.darwin.pc = {
    imports = [ darwin.base ];
    people.home.imports = [ homeManager.pc ];
  };

  flake.modules.homeManager.base =
    { config, ... }:
    {
      programs.home-manager.enable = true;
      home.sessionVariables = {
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      };
    };
}
