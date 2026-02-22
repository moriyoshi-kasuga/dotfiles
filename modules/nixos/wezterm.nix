{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "term.wezterm";
  module = {
    users.users.${username}.packages = [
      pkgs.wezterm
    ];
  };
}
