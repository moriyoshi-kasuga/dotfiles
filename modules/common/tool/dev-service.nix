_:

{
  flake.modules.homeManager."tool.dev-service" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        prek
        oha
        supabase-cli
        postgresql
      ];
    };
}
