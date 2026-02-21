{
  mkModule,
  pkgs,
  ...
}:

let
  package = pkgs.delta;
  cmd = pkgs.lib.getExe package;
in
mkModule {
  name = "delta";
  module = {
    home.packages = [
      package
    ];

    programs.git.iniContent = {
      core.pager = "${cmd} --diff-so-fancy";
      interactive.diffFilter = "${cmd} --diff-so-fancy --color-only";
      delta = {
        line-numbers = true;
        navigate = true;
      };
    };
  };
}
