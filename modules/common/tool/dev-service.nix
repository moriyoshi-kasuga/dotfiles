_:

{
  flake.modules.homeManager.base =
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
