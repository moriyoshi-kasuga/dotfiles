_:

{
  flake.modules.homeManager."lang.bash" =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = with pkgs; [
        bash-language-server
        shellcheck
        shfmt
      ];
    };
}
