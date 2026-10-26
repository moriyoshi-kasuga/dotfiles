{
  ...
}:

{
  flake.modules.homeManager.omniwm = _: {
    programs.omniwm = {
      enable = true;
      settings = ./omniwm.toml;
    };
  };
}
