_:

{
  flake.modules.homeManager."lang.node" =
    { pkgs, lib, ... }:
    {
      programs.mise.globalConfig.tools = {
        deno = "2.8.0";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin { node = "24.15.0"; };

      home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.nodejs_24 ];
    };
}
