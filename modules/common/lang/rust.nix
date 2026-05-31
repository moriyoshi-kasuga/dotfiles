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

      cargo-msrv
      cargo-nextest
      cargo-udeps
      cargo-tauri
      cargo-release
      cargo-audit
      cargo-outdated
      cargo-deny
      cargo-show-asm
      cargo-make
    ];
  };
}
