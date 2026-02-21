{
  mkModule,
  ...
}:

mkModule {
  name = "fish";
  module = {
    module.shell.enable = true;
    programs.fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./init.fish;
    };
  };
}
