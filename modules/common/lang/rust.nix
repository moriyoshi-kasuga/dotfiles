{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.rust";
  inheritModule = "lang";
  homeModule = {
    programs.zsh.initContent = ''
      export PATH="$PATH:~/.cargo/bin"
    '';

    programs.fish.interactiveShellInit = ''
      fish_add_path ~/.cargo/bin
    '';

    home.packages = with pkgs; [
      rustup
      mold
      wild

      cargo-hack
      cargo-msrv
      cargo-nextest
      cargo-udeps
      cargo-machete
      cargo-tauri
      cargo-release
      cargo-audit
      cargo-outdated
      cargo-deny
      cargo-show-asm
      cargo-make
    ];
  };
  darwinHomeModule = {
    # GNU ld (from hiPrio gcc in lang.c) does not emit __unwind_info in Mach-O,
    # so panic unwinding (catch_unwind / #[should_panic]) silently aborts.
    # Force Cargo to use Apple's ld64-backed cc for the native Darwin target.
    home.sessionVariablesExtra = ''
      export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER="$(xcrun --find cc)"
    '';
  };
}
