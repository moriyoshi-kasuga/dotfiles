{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jdk21_headless
    gradle-unwrapped
    scala
    sbt
  ];
}
