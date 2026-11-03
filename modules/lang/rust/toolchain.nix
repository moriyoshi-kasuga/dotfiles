_:

{
  flake.modules.homeManager."lang.rust" =
    { pkgs, lib, ... }:
    {
      programs.fish.interactiveShellInit = ''
        fish_add_path -g ~/.cargo/bin
      '';

      # CARGO_INCREMENTAL stays unset: kache's adaptive incremental mode gives
      # crates under edit incremental state, and CARGO_INCREMENTAL=0 disables it.
      # mold is a fallback: `cargo build --config 'target."cfg(target_os = \"linux\")".rustflags=["-C","link-arg=-fuse-ld=mold"]'`
      # if wild fails to link a specific crate.
      home.file.".cargo/config.toml".text = ''
        [build]
        rustc-wrapper = "kache"

        [target.'cfg(target_os = "linux")']
        rustflags = ["-C", "link-arg=-fuse-ld=wild"]

        [net]
        git-fetch-with-cli = true
      '';

      home.packages = [
        pkgs.rustup
        pkgs.kache
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.wild ];

      programs.claude-code.settings.permissions.allow = [
        "Bash(rustc *)"
        "Bash(cargo build *)"
        "Bash(cargo clippy *)"
        "Bash(cargo fmt *)"
        "Bash(cargo check *)"
        "Bash(cargo test *)"
        "Bash(cargo nextest *)"
        "Bash(cargo doc *)"
      ];
    };
}
