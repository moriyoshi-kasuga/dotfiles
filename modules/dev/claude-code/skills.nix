{ inputs, ... }:

{
  flake.modules.homeManager.base =
    { lib, ... }:
    let
      # Claude Code only loads skills/<name>/SKILL.md, so nested category
      # directories are walked and flattened by skill directory name.
      findSkills =
        dir:
        lib.concatMap (
          name:
          let
            path = "${dir}/${name}";
          in
          if builtins.pathExists "${path}/SKILL.md" then
            [ (lib.nameValuePair name path) ]
          else
            findSkills path
        ) (lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)));

      # mattpocock-skills is installed as plain skills rather than as a plugin:
      # its skills call each other by unprefixed name (e.g. "codebase-design"),
      # which a plugin would namespace as "mattpocock-skills:codebase-design".
      skillList =
        lib.concatMap findSkills [
          "${inputs.mattpocock-skills}/skills/in-progress"
          "${inputs.mattpocock-skills}/skills/misc"
          "${inputs.mattpocock-skills}/skills/engineering"
          "${inputs.mattpocock-skills}/skills/productivity"
          "${inputs.anthropic-skills}/skills"
        ]
        ++ [ (lib.nameValuePair "rust-skills" "${inputs.leonardomso-rust-skills}") ];

      duplicateSkills = lib.attrNames (
        lib.filterAttrs (_: v: builtins.length v > 1) (lib.groupBy (s: s.name) skillList)
      );
    in
    {
      assertions = [
        {
          assertion = duplicateSkills == [ ];
          message = "duplicate Claude Code skill names: ${lib.concatStringsSep ", " duplicateSkills}";
        }
      ];

      programs.claude-code = {
        commandsDir = ../../../commands;
        skills = lib.listToAttrs skillList;
        plugins.superpowers = inputs.obra-superpowers;
      };
    };
}
