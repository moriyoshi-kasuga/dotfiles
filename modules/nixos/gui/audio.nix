_:

{
  flake.modules.nixos."gui.audio" =
    { config, pkgs, ... }:
    {
      users.users.${config.people.primaryUser}.extraGroups = [
        "audio"
      ];

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        audio.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      environment.systemPackages = with pkgs; [
        alsa-utils
        pulseaudio
        easyeffects
      ];
    };
}
