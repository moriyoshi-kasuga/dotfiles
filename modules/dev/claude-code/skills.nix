{ inputs, ... }:

{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    let
      fromDir = dir: map (rel: lib.nameValuePair (baseNameOf rel) "${dir}/${rel}");

      # mattpocock-skills is installed as plain skills rather than as a plugin:
      # its skills call each other by unprefixed name (e.g. "codebase-design"),
      # which a plugin would namespace as "mattpocock-skills:codebase-design".
      skills =
        fromDir "${inputs.mattpocock-skills}/skills" [
          "productivity/grilling"
          "productivity/grill-me"
          "productivity/handoff"
          "productivity/teach"
          "productivity/writing-for-agents"
          "engineering/codebase-design"
          "engineering/improve-codebase-architecture"
          "engineering/domain-modeling"
          "engineering/code-review"
          "engineering/research"
          "engineering/prototype"
          "engineering/pr"
        ]
        ++ fromDir "${inputs.anthropic-skills}/skills" [
          "claude-api"
          "frontend-design"
          "webapp-testing"
        ];

      # The thought-bug command replaces systematic-debugging, so the remaining
      # superpowers skills that send bugs there are pointed at it instead.
      superpowers = pkgs.runCommand "superpowers" { } ''
        cp -r ${inputs.obra-superpowers} $out
        chmod -R u+w $out
        rm -r $out/skills/systematic-debugging
        find $out/skills -name '*.md' -exec sed -i 's/\(superpowers:\)\?systematic-debugging/thought-bug/g' {} +
      '';
    in
    {
      programs.claude-code = {
        commandsDir = ../../../commands;
        skills = lib.listToAttrs skills;
        plugins = { inherit superpowers; };
      };
    };
}
