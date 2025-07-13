{ pkgs, ... }:

{
  home.packages = [
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "TaggedFileFlow";
      version = "2.0.0";

      src = pkgs.fetchFromGitHub {
        owner = "moriyoshi-kasuga";
        repo = "TaggedFileFlow";
        rev = "v${version}";
        hash = "sha256-ibVIZnA9z2HSW1EXLA7qEcGK332Jy08yYBp+LFmGsv8=";
      };

      useFetchCargoVendor = true;
      cargoHash = "sha256-OiKmOCHAjVT9GuEHbr2GGaYazoaKN1wVscnoylRoL9Y=";
    })
  ];

  programs.zsh.initContent = ''
    eval "$(tagged_file_flow init)"
  '';
}
