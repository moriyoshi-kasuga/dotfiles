{ inputs, ... }:

let
  # nixos/darwin 共通の nix.* 設定。OS 固有の差分は各 class の module に書き足し、module system に merge させる。
  common.nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
    };
    # OS 側の既定でも同じ store path が登録されるが、flake として渡すと rev / narHash も entry に入る
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ common ];

      nix = {
        package = pkgs.nixVersions.latest;
        channel.enable = false;
        # 既定 (max-jobs = CPU 数, cores = 0 は全コア) だと 16 並列 x 16 スレッドまで膨らみ、
        # メモリを使い切ってデスクトップごと固まる
        settings = {
          max-jobs = 4;
          cores = 8;
        };
        gc.dates = "weekly";
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
    imports = [ common ];

    nix.gc.interval = {
      Weekday = 1;
      Hour = 0;
      Minute = 0;
    };
  };
}
