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
  name = "tool.git.delta";
  inheritModule = "tool.git";
  homeModule = {
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
