{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.fsharp";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      dotnet-sdk
    ];
  };
}
