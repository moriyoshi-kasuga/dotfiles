{
  mkModule,
  ...
}:

mkModule {
  name = "wezterm";
  module = {
    homebrew.casks = [
      "wezterm"
    ];
  };
}
