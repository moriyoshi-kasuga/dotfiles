{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.fsharp";
  module = {
    home.packages = with pkgs; [
      dotnet-sdk
    ];
  };
}
