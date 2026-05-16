{
  pkgs,
  mkModule,
  ...
}:

let
  java = pkgs.graalvmPackages.graalvm-ce;
in
mkModule {
  name = "lang.jvm";
  inheritModule = "lang";
  homeModule = {
    home.sessionVariables = {
      MILL_JVM_VERSION = "system";
    };
    programs.java = {
      enable = true;
      package = java;
    };
    home.packages =
      with pkgs;
      [
        (gradle.override {
          jre = java;
        })
        (sbt.override {
          jre = java;
        })
        (mill.override {
          jre = java;
        })
        (coursier.override {
          jre = java;
        })
        (jdt-language-server.override {
          jdk = java;
        })
        (metals.override {
          jre = java;
        })
        (scala-next.override {
          scala = pkgs.scala.override { jre = java; };
        })
        (scala-cli.override {
          jre = java;
        })
      ]
      ++ [ java ];
  };
}
