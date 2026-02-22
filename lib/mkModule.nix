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
  # name を path に正規化
  path =
    if builtins.isList name then
      name
    else if builtins.isString name then
      splitString "." name
    else
      abort "mkModule: name must be string or list";

  optionPath = [ "modules" ] ++ path;

  # cfg 参照
  cfg = attrByPath optionPath { } config;

  # enable option
  enableOption = setAttrByPath optionPath {
    enable = mkEnableOption (concatStringsSep "." path);
  };

  # extra options
  extraOptions =
    let
      evaluated = if builtins.isFunction options then options { inherit lib config; } else options;
    in
    setAttrByPath optionPath evaluated;

in
{
  options = recursiveUpdate enableOption extraOptions;

  config = mkIf cfg.enable (module cfg);
}
