_:

{
  flake.modules.nixos."gui.zed" =
    { config, pkgs, ... }:
    {
      users.users.${config.people.primaryUser} = {
        packages = with pkgs; [
          zed-editor-fhs
        ];
      };
    };
}
