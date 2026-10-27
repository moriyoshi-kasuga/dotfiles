_:

{
  flake.modules.homeManager."lang.jvm" =
    { pkgs, ... }:
    let
      java = pkgs.graalvmPackages.graalvm-ce;

      # Lombok は javaagent として JVM の起動時に渡す必要があるので、jdtls 自体に組み込む。
      # どのエディタから起動しても同じ jdtls になる。
      jdtls = pkgs.symlinkJoin {
        name = "jdtls-with-lombok";
        paths = [ (pkgs.jdt-language-server.override { jdk25 = java; }) ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/jdtls \
            --add-flags "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar"
        '';
      };
    in
    {
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
          jdtls
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
