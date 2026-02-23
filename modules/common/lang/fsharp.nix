{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.fsharp";
  homeModule = {
    home.packages = with pkgs; [
      dotnet-sdk
    ];
  };
}
