_:

{
  flake.modules.homeManager."lang.buf" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        buf
        protobuf
      ];
    };
}
