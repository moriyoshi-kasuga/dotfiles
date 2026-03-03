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
  path =
    if isList name then
      name
    else if isString name then
      splitString "." name
    else
      abort "mkModule: name must be string or list";

  optionPath = [ "modules" ] ++ path;

  cfg = attrByPath optionPath { } config;

  fnArgs = { inherit cfg config; };
  evalModule = module: if lib.isFunction module then module fnArgs else module;

  module =
    if "home" == platform then
      recursiveUpdate (evalModule homeModule) (
        if "nixos" == host then
          evalModule linuxHomeModule
        else if "darwin" == host then
          evalModule darwinHomeModule
        else
          { }
      )
    else if "nixos" == platform then
      evalModule nixosModule
    else if "darwin" == platform then
      evalModule darwinModule
    else
      abort "Invalid platform: ${platform}";

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

  common = evalModule commonModule;

  commonImports = common.imports or [ ];
  moduleImports = module.imports or [ ];

  commonConfig = removeAttrs common [ "imports" ];
  moduleConfig = removeAttrs module [ "imports" ];
in
{
  imports = commonImports ++ moduleImports;

  options = attrOptions;

  config = mkIf effectiveEnable (recursiveUpdate commonConfig moduleConfig);
}
