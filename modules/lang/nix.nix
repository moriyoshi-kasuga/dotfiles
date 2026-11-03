_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
    };
}
