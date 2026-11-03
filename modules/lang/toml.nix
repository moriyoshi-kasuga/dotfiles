_:

{
  flake.modules.homeManager."lang.toml" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = [ pkgs.taplo ];
    };
}
