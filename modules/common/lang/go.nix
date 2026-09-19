_:

{
  flake.modules.homeManager."lang.go" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        go
        gopls
        golangci-lint
        delve
        gotools
      ];
    };
}
