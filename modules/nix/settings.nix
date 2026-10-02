{ inputs, ... }:

let
  # nixos/darwin 共通の nix.* 設定。ホスト固有の差分は gc に対する `//` で追加する。
  mkNixCommon =
    {
      extraGc ? { },
    }:
    {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = false;
        # 大きなクロージャの substitute でバッファや並列数が詰まらないようにする
        download-buffer-size = 268435456;
        http-connections = 64;
        max-substitution-jobs = 32;
        # ビルド中に空きが min-free を下回ったら max-free まで GC する
        min-free = 5 * 1024 * 1024 * 1024;
        max-free = 20 * 1024 * 1024 * 1024;
      };
      optimise.automatic = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      }
      // extraGc;
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
      };
    };
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      nix =
        mkNixCommon {
          extraGc.dates = "weekly";
        }
        // {
          package = pkgs.nixVersions.latest;
          channel.enable = false;
        };
    };

  flake.modules.darwin.base = {
    nix = mkNixCommon {
      extraGc.interval = {
        Weekday = 1;
        Hour = 0;
        Minute = 0;
      };
    };
  };
}
