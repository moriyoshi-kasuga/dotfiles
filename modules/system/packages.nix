_:

{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim-full
        wget
        pciutils
      ];
    };
}
