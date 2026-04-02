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
        version = "3.0.2";

        src = pkgs.fetchFromGitHub {
          owner = "moriyoshi-kasuga";
          repo = "TaggedFileFlow";
          rev = "v${version}";
          hash = "sha256-TFMGPv2Wf1e5waFEXaYIGiQn8WK4tJFs07YyikBBWA8=";
        };

        cargoHash = "sha256-uFTioWESs/E8K/FPxVx8+D1oFDptG0uBE8YYHifHbz8=";
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
