{
  mkModule,
  ...
}:

mkModule {
  name = "nixos";
  nixosModule = {
    imports = [
      # めんどくさいから一旦このままにして、modulerの設計に完全移行できたら細分化する
      ./desktop
      ./hardware-configuration.nix
      ./hardware
      ./system
      ./users
    ];
  };
}
