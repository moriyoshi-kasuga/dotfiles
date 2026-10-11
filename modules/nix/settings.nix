{ inputs, ... }:

let
  # nixos/darwin 共通の nix.* 設定。OS 固有の差分は settings や gc に対する `//` で追加する。
  mkNixCommon =
    {
      extraSettings ? { },
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
      }
      // extraSettings;
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
          # 既定 (max-jobs = CPU 数, cores = 0 は全コア) だと 16 並列 x 16 スレッドまで膨らみ、
          # メモリを使い切ってデスクトップごと固まる
          extraSettings = {
            max-jobs = 4;
            cores = 8;
          };
          extraGc.dates = "weekly";
        }
        // {
          package = pkgs.nixVersions.latest;
          channel.enable = false;
          # ビルド中も対話的な処理を優先させる
          daemonCPUSchedPolicy = "batch";
          daemonIOSchedClass = "idle";
        };

      # ビルドが暴走したときに止まるのはデスクトップではなくビルド側にする。
      # MemoryHigh で reclaim して減速させ、それでも MemoryMax に達したら cgroup 内で OOM kill される。
      systemd.services.nix-daemon.serviceConfig = {
        MemoryHigh = "60%";
        MemoryMax = "80%";
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
