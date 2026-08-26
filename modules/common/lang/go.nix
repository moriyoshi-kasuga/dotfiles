_:

{
  flake.modules.homeManager."lang.go" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        go
      ];
    };
}
