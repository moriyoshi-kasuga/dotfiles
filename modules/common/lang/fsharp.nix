_:

{
  flake.modules.homeManager."lang.fsharp" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dotnet-sdk
      ];
    };
}
