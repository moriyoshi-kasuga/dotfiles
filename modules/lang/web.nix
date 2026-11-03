_:

{
  # HTML / CSS / JSON と ESLint の language server
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.extraPackages = [ pkgs.vscode-langservers-extracted ];
    };
}
