_:

{
  flake.modules.homeManager."lang.github-actions" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = [ pkgs.actionlint ];
    };
}
