{
  # options name, split by dot
  name,
  # spatial options
  options ? { },
  # for all module config
  commonModule ? { },
  # with home-manager (home-manager for linux and darwin)
  homeModule ? { },
  # with home-manger (home-manager for linux)
  linuxHomeModule ? { },
  # with nixosConfiguration (include unique nixos config)
  nixosModule ? { },
  # with home-manager (home-manager for darwin)
  darwinHomeModule ? { },
  # with nix-darwin (include GUI and mac config)
  darwinModule ? { },
}:

{
  lib,
  config,
  platform,
  host,
  ...
}:

with lib;

let
  module =
    if "home" == platform then
      recursiveUpdate homeModule (
        if "nixos" == host then
          linuxHomeModule
        else if "darwin" == host then
          darwinHomeModule
        else
          { }
      )
    else if "nixos" == platform then
      nixosModule
    else if "darwin" == platform then
      darwinModule
    else
      abort "Invalid platform: ${platform}";

  path =
    if builtins.isList name then
      name
    else if builtins.isString name then
      splitString "." name
    else
      abort "mkModule: name must be string or list";

  optionPath = [ "modules" ] ++ path;

  cfg = attrByPath optionPath { } config;

  mergedOption = recursiveUpdate {
    enable = mkEnableOption (concatStringsSep "." path);
  } options;

  attrOptions = setAttrByPath optionPath mergedOption;

  common = if lib.isFunction commonModule then commonModule cfg else commonModule;
  module' = if lib.isFunction module then module cfg else module;
  normalizeImport =
    value:
    if builtins.isPath value || builtins.isString value then
      let
        path = toString value;
        nixPath = "${path}.nix";
      in
      if builtins.pathExists path then
        path
      else if builtins.pathExists nixPath then
        nixPath
      else
        value
    else
      value;
  commonImports = builtins.map normalizeImport (common.imports or [ ]);
  moduleImports = builtins.map normalizeImport (module'.imports or [ ]);
  commonConfig = builtins.removeAttrs common [ "imports" ];
  moduleConfig = builtins.removeAttrs module' [ "imports" ];
in
{
  imports = commonImports ++ moduleImports;

  options = attrOptions;

  config = mkIf cfg.enable (recursiveUpdate commonConfig moduleConfig);
}
