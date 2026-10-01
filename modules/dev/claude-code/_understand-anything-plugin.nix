{
  lib,
  stdenv,
  fetchPnpmDeps,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
  src,
}:

# The skills import packages/core/dist and try to `pnpm install` into the
# plugin root when it is missing, which fails in the read-only store, so
# core is prebuilt here. Hooks call bare `node`, pinned to an absolute
# path so they work without nodejs on PATH.
stdenv.mkDerivation (finalAttrs: {
  pname = "understand-anything-plugin";
  version = "2.9.7";
  src = "${src}/understand-anything-plugin";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-Zq6rdL+DJ3J9fm5yNPtHPygHTfIbOSLaX3M5emat+RY=";
  };
  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];
  buildPhase = ''
    runHook preBuild
    pnpm --filter @understand-anything/core build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    sed -i 's|\bnode |${lib.getExe nodejs} |g' hooks/hooks.json
    cp -r . $out
    runHook postInstall
  '';
})
