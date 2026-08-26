_:

{
  flake.modules.homeManager."lang.elm" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        elmPackages.elm
      ];
    };
}
