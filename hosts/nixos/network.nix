{
  vars,
  ...
}:

{
  networking.hostName = "${vars.username}-NixOS";
  networking.networkmanager.enable = true;
}
