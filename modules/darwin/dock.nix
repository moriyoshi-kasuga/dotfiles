{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.dock";
  darwinModule = {
    system.defaults.dock = {
      autohide = true;
      show-recents = false;
      tilesize = 50;
      magnification = true;
      largesize = 64;
      orientation = "bottom";
      mineffect = "scale";
      launchanim = false;
    };
  };
}
