_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        supabase-cli
        postgresql
      ];
    };
}
