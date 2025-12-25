{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jdk21_headless

    gradle-unwrapped

    scala-next
    sbt
    coursier
    scalafmt
    scalafix
  ];
}
