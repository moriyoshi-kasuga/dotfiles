_:

{
  flake.modules.nixos.base = {
    # ディスクの劣化を SMART で検知する
    services.smartd.enable = true;
    # `fwupdmgr update` でマザーボードや NVMe のファームウェアを更新できるようにする
    services.fwupd.enable = true;
  };

  flake.modules.nixos.pc = {
    # 既定の wall 通知は tty にしか出ないので、デスクトップ通知でも知らせる
    services.smartd.notifications.systembus-notify.enable = true;
  };
}
