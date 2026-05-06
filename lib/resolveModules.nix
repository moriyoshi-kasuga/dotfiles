specialArgs: modules:

let
  loadModule =
    module:
    if builtins.isPath module || builtins.isString module then
      if builtins.pathExists module then import module else abort "resolveModules: path not found: ${toString module}"
    else
      module;

  collectModules =
    module:
    let
      current = loadModule module;
    in
    if builtins.isFunction current then
      let
        functionArgs = builtins.functionArgs current;
      in
      if builtins.hasAttr "mkModule" functionArgs || builtins.hasAttr "mkEnableOption" functionArgs then
        collectModules (current specialArgs)
      else
        [ current ]
    else if builtins.isAttrs current && current ? imports then
      [ (removeAttrs current [ "imports" ]) ] ++ builtins.concatMap collectModules current.imports
    else
      [ current ];
in
builtins.concatMap collectModules modules
