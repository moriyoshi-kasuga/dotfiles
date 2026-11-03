_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        bash-language-server
        shellcheck
        shfmt
      ];
    };
}
