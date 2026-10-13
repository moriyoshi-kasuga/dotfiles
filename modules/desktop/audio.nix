_:

{
  flake.modules.nixos.pc =
    { config, pkgs, ... }:
    {
      users.users.${config.people.primaryUser}.extraGroups = [
        "audio"
      ];

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # pipewire.service の後に起動し、pipewire の再起動に追従して、
      # 停止時も pipewire より先に終わる (spawn-at-startup だとシャットダウンの度に ABRT していた)
      people.home.imports = [ { services.easyeffects.enable = true; } ];

      environment.systemPackages = with pkgs; [
        alsa-utils
        # pulseaudio パッケージを丸ごと入れると、pipewire-pulse が落ちたときに
        # libpulse が本物の pulseaudio デーモンを autospawn しうるので pactl だけ入れる
        (runCommand "pactl" { } ''
          mkdir -p $out/bin
          ln -s ${pulseaudio}/bin/pactl $out/bin/pactl
        '')
      ];
    };
}
