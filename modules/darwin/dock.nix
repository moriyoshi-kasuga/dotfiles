{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.dock";
  inheritModule = "darwin";
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
    system.defaults.spaces.spans-displays = true;
  };
}
