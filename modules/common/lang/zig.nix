_:

{
  flake.modules.homeManager."lang.zig" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        zig
      ];
    };
}
