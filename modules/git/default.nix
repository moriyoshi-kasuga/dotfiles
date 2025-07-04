{
  programs.git = {
    enable = true;
  };

  home.file.".gitconfigs".source = ./.gitconfigs;
}
