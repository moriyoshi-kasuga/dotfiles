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
        ++ lib.optionals pkgs.stdenv.isDarwin (
          with pkgs;
          [
            libcxx
            (lib.hiPrio llvmPackages.clang-unwrapped)
          ]
        )
        ++ lib.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            mold
            (lib.hiPrio clang)
          ]
        );

      home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
        CFLAGS = "-fuse-ld=mold";
        CXXFLAGS = "-fuse-ld=mold";
        LDFLAGS = "-fuse-ld=mold";
      };
    };
}
