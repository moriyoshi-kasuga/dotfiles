_:

let
  dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
in
{
  flake.modules.homeManager.base = {
    programs.lazydocker.enable = true;

    home.file.".config/docker/daemon.json".text = builtins.toJSON { inherit dns; };

    home.shellAliases = {
      d = "docker";
      dc = "docker compose";
      dcps = "docker compose ps";
      dcud = "docker compose up -d";
      dcudb = "docker compose up -d --build";
      dce = "docker compose exec";
      dcl = "docker compose logs";
      dcd = "docker compose down";
      dcs = "docker compose stop";
      dcb = "docker compose build";
      dcbnc = "docker compose build --no-cache";
    };
  };

  flake.modules.nixos.base = {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = { inherit dns; };
      };
    };
  };

  # 画面のある host では起動時に dockerd を立ち上げず、docker.socket 経由で初回利用時に起動する。
  # 起動が network-online.target 待ちに引きずられず、使わない日はメモリも食わない。
  # (常時稼働のコンテナを置く server では従来どおり起動時に立ち上げる)
  flake.modules.nixos.pc = {
    virtualisation.docker.enableOnBoot = false;
  };

  # homebrew は darwin.pc でだけ有効にしている
  flake.modules.darwin.pc = {
    homebrew.casks = [
      "docker-desktop"
    ];
  };
}
