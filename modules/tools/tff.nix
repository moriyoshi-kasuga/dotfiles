{ pkgs, ... }:

{
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

      useFetchCargoVendor = true;
      cargoHash = "sha256-a4kAnj+t0027k2nEeEBG1BZXqjjdY5gHYGomZCSoHfE=";
    })
  ];

  programs.zsh.initContent = ''
    eval "$(tagged_file_flow init zsh)"
  '';
}
