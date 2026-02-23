{
  mkModule,
  ...
}:

mkModule {
  name = "darwin.finder";
  darwinModule = {
    system.defaults.finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };
}
