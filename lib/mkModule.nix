{
  # options name, split by dot
  name,
  inheritModule ? "",
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
    if isList name then
      name
    else if isString name then
      splitString "." name
    else
      abort "mkModule: name must be string or list";

  optionPath = [ "modules" ] ++ path;

  cfg = attrByPath optionPath { } config;

  inheritPath =
    if inheritModule == "" then
      null
    else if isList inheritModule then
      inheritModule
    else if isString inheritModule then
      splitString "." inheritModule
    else
      abort "mkModule: inheritModule must be string or list";

  inheritedCfg =
    if inheritPath == null then
      { enable = false; }
    else
      attrByPath ([ "modules" ] ++ inheritPath) { } config;

  effectiveEnable = cfg.enable || inheritedCfg.enable;

  # -------------------------

  mergedOption = recursiveUpdate {
    enable = mkEnableOption (concatStringsSep "." path);
  } options;

  attrOptions = setAttrByPath optionPath mergedOption;

  common = if lib.isFunction commonModule then commonModule cfg else commonModule;
  module' = if lib.isFunction module then module cfg else module;

  commonImports = common.imports or [ ];
  moduleImports = module'.imports or [ ];

  commonConfig = removeAttrs common [ "imports" ];
  moduleConfig = removeAttrs module' [ "imports" ];

in
{
  imports = commonImports ++ moduleImports;

  options = attrOptions;

  config = mkIf effectiveEnable (recursiveUpdate commonConfig moduleConfig);
}
