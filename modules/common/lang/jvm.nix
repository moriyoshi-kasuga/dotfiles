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
      jdk25
      gradle

      scala-next
      sbt
      mill
      (metals.override {
        jre = jdk25;
      })
    ];
  };
}
