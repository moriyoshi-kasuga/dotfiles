{
  mkModule,
  ...
}:

mkModule {
  name = "shell.fish";
  module = {
    modules.shell.enable = true;
    programs.fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./init.fish;
    };
  };
}
