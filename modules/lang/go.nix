_:

{
  flake.modules.homeManager."lang.go" =
    { pkgs, ... }:
    {
      # golangci-lint / delve / gotools は nvim から使わず端末で使う
      home.packages = with pkgs; [
        go
        golangci-lint
        delve
        gotools
      ];
      programs.neovim.extraPackages = [ pkgs.gopls ];
    };
}
