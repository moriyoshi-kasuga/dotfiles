{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "fsharp";
  module = {
    home.packages = with pkgs; [
      dotnet-sdk
    ];
  };
}
