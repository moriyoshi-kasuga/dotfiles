specialArgs: modules:

let
  importPath =
    module:
    let
      modulePath = toString module;
      moduleNixPath = "${modulePath}.nix";
    in
    if builtins.pathExists modulePath then
      {
        found = true;
        path = modulePath;
      }
    else if builtins.pathExists moduleNixPath then
      {
        found = true;
        path = moduleNixPath;
      }
    else
      {
        found = false;
        path = modulePath;
      };

  collectModules =
    module:
    let
      current =
        if builtins.isPath module || builtins.isString module then
          let
            resolved = importPath module;
          in
          if resolved.found then import resolved.path else module
        else
          module;
    in
    if builtins.isFunction current then
      let
        functionArgs = builtins.functionArgs current;
      in
      if builtins.hasAttr "mkModule" functionArgs then
        collectModules (current specialArgs)
      else
        [ current ]
    else if builtins.isAttrs current && current ? imports then
      [ (removeAttrs current [ "imports" ]) ] ++ builtins.concatMap collectModules current.imports
    else
      [ current ];
in
builtins.concatMap collectModules modules
