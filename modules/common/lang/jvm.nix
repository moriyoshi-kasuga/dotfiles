{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.jvm";
  homeModule = {
    home.packages = with pkgs; [
      jdk21_headless

      gradle

      scala-next
      sbt
      coursier
      scalafmt
      scalafix
    ];
  };
}
