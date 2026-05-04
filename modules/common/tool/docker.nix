{
  mkModule,
  ...
}:

mkModule {
  name = "tool.docker";
  inheritModule = "tool";
  homeModule = {
    programs.lazydocker.enable = true;

    home.file.".config/docker/daemon.json".text = builtins.toJSON {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };

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
  nixosModule = {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
        rootless = {
          enable = true;
          setSocketVariable = true;
          daemon.settings = {
            dns = [
              "1.1.1.1"
              "8.8.8.8"
            ];
          };
        };
      };
    };
  };
  darwinModule = {
    homebrew.casks = [
      "docker-desktop"
    ];
  };
}
