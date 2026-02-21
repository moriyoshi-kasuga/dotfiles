{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "jvm";
  module = {
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
