{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "tff";
  module = {
    home.packages = [
      (pkgs.rustPlatform.buildRustPackage rec {
        pname = "TaggedFileFlow";
        version = "3.0.0";

        src = pkgs.fetchFromGitHub {
          owner = "moriyoshi-kasuga";
          repo = "TaggedFileFlow";
          rev = "v${version}";
          hash = "sha256-TrKhemh+ZL51v//x24CYritSACtSjpomHFNYH2pn7z8=";
        };

        cargoHash = "sha256-a4kAnj+t0027k2nEeEBG1BZXqjjdY5gHYGomZCSoHfE=";
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
