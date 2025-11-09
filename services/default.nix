{ lib, ... }:

{
  imports = [
    ./traefik
    ./immich.nix
    ./jellyfin.nix
    ./homepage.nix
  ];

  options = {
    serviceSettings.domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain of the device";
    };

    serviceSettings.nasIp = lib.mkOption {
      type = lib.types.str;
      description = "IP adress of the local NAS";
    };
  };
}
