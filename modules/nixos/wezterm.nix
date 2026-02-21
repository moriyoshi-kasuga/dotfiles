{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "wezterm";
  module = {
    users.users.${username}.packages = [
      pkgs.wezterm
    ];
  };
}
