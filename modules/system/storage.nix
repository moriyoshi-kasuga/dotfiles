_:

{
  flake.modules.nixos.base = {
    # ディスクの劣化を SMART で検知する
    services.smartd.enable = true;
    # `fwupdmgr update` でマザーボードや NVMe のファームウェアを更新できるようにする
    services.fwupd.enable = true;
  };
}
