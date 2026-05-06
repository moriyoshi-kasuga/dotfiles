{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.jvm";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      jdk21
      gradle

      scala-next
      sbt
      coursier
      metals
    ];
  };
}
