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
      jdk21_headless
      gradle

      scala-next
      sbt
      coursier
      metals
    ];
  };
}
