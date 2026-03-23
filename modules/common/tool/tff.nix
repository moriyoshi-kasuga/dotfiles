{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "tool.tff";
  inheritModule = "tool";
  homeModule = {
    home.packages = [
      (pkgs.rustPlatform.buildRustPackage rec {
        pname = "TaggedFileFlow";
        version = "3.0.1";

        src = pkgs.fetchFromGitHub {
          owner = "moriyoshi-kasuga";
          repo = "TaggedFileFlow";
          rev = "v${version}";
          hash = "sha256-ez7g8CLEIW5OpKtaIzwLPgBhLhfmaHbCS07YxjgqHWc=";
        };

        cargoHash = "sha256-js04R0ujCN76llEbylb9O0YBtMNhtFQQs0IziuCzy2o=";
      })
    ];

    programs.zsh.initContent = ''
      eval "$(tagged_file_flow init zsh)"
    '';

    programs.fish.interactiveShellInit = ''
      tagged_file_flow init fish | source
    '';
  };
}
