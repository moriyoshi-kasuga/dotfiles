{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.tailscale";
  darwinModule = {
    services.tailscale.enable = true;
  };
}
