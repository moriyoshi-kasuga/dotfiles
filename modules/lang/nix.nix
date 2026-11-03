_:

{
  flake.modules.homeManager."lang.nix" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
    };
}
