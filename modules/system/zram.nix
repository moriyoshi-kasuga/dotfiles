_:

{
  flake.modules.nixos.base = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    # zram はディスク swap よりずっと速いので積極的に使わせ、
    # 先読み (2^page-cluster ページ) も無駄になるので切る
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
  };
}
