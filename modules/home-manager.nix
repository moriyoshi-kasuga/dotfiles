{ config, inputs, ... }:

let
  inherit (config.flake.modules) nixos darwin homeManager;

  homeManagerCommon = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
in
{
  # 層の配線: base は全 host、pc は画面を持つ host。
  # homeManager.base は全 host の primaryUser に入る。層や OS で絞る home 設定は、
  # 各ファイルが nixos.<層> / darwin.<層> の people.home.imports から入れる。
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

  flake.modules.nixos.pc.imports = [ nixos.base ];
  flake.modules.darwin.pc.imports = [ darwin.base ];

  flake.modules.homeManager.base =
    { config, ... }:
    {
      programs.home-manager.enable = true;
      home.sessionVariables = {
        XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      };
    };
}
