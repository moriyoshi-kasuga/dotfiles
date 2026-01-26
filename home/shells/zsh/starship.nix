{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      package.disabled = true;

      java.disabled = true;
      kotlin.disabled = true;
      gradle.disabled = true;
      scala.disabled = true;
      aws.disabled = true;
    };
  };
}
