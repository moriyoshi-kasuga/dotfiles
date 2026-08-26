_:

{
  flake.modules.homeManager."lang.c" =
    { pkgs, lib, ... }:
    {
      home.packages =
        (with pkgs; [
          gnumake
          lld
          cmake
          ninja
        ])
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
          with pkgs;
          [
            libcxx
            (lib.hiPrio llvmPackages.clang-unwrapped)
          ]
        )
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
          with pkgs;
          [
            mold
            (lib.hiPrio clang)
          ]
        );

      home.sessionVariables = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        CFLAGS = "-fuse-ld=mold";
        CXXFLAGS = "-fuse-ld=mold";
        LDFLAGS = "-fuse-ld=mold";
      };
    };
}
