{
  lib,
  config,
  ...
}:

{
  name,
  module,
  options ? { },
}:

with lib;
let
  cfg = config.modules."${name}";
in
{
  options.modules."${name}" = {
    enable = mkEnableOption name;
  }
  // options;

  config = mkIf cfg.enable module { inherit cfg; };
}
