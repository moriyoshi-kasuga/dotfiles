{
  mkModule,
  ...
}:

mkModule {
  name = "nixos.docker";
  inheritModule = "nixos";
  nixosModule = {
    virtualisation = {
      docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
