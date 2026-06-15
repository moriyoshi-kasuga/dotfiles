{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.tailscale";
  inheritModule = "darwin";
  darwinModule = {
    services.tailscale.enable = true;
  };
}
