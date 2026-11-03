_:

{
  flake.modules.homeManager."lang.rust" =
    { pkgs, lib, ... }:
    {
      # Ensure Cargo links with Apple's ld64-backed cc for the native Darwin target,
      # since a GNU ld-based toolchain silently breaks panic unwinding
      # (catch_unwind / #[should_panic]) by omitting __unwind_info in Mach-O.
      # cc-rs builds the C/C++ parts of crates with the same Apple toolchain.
      home.sessionVariablesExtra = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
        export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER="$(xcrun --find cc)"
        export CC_aarch64_apple_darwin=/usr/bin/cc
        export CXX_aarch64_apple_darwin=/usr/bin/c++
      '';
    };
}
