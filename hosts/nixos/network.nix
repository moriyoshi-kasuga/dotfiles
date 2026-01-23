{
  username,
  ...
}:

{
  networking.hostName = "${username}-NixOS";
  networking.networkmanager.enable = true;
}
