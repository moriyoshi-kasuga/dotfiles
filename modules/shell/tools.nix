_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # use latest version
        bash
      ];

      programs = {
        direnv = {
          enable = true;
          enableZshIntegration = false;
          nix-direnv.enable = true;
        };
        zoxide = {
          enableZshIntegration = false;
          enable = true;
        };
        eza.enable = true;
      };

      home.sessionVariables = {
        _ZO_EXCLUDE_DIRS = "$HOME:/tmp/*:/var/*:/nix/*:/mnt/*";
      };

      home.shellAliases = {
        ".." = "cd ../";
        "..." = "cd ../../";
        e = "exit";

        l = "eza";
        ll = "eza --long --git";
        la = "eza --all";
        lsa = "eza --all --long";
        lt = "eza --tree --git-ignore";
      };
    };
}
