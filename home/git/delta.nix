{ pkgs, ... }:

let
  package = pkgs.delta;
  cmd = pkgs.lib.getExe package;
in
{
  home.packages = [
    package
  ];

  programs.git.iniContent = {
    core.pager = "${cmd} --diff-so-fancy";
    interactive.diffFilter = "${cmd} --color-only";
    delta = {
      line-numbers = true;
      navigate = true;
    };
  };
}
