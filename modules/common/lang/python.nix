_:

{
  flake.modules.homeManager."lang.python" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        python3
        python3Packages.pip
        uv
      ];
    };
}
