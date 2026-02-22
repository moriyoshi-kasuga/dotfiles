{
  mkModule,
  ...
}:

mkModule {
  name = "term.wezterm";
  module = {
    homebrew.casks = [
      "wezterm"
    ];
  };
}
