{ config, lib, ... }:

let
  cfg = config.serviceSettings.immich;
  port = 2283;
  traefik-utils = import ./traefik/utils.nix;
in
{
  options = {
    serviceSettings.immich = {
      enable = lib.mkEnableOption "Enable immich";

      url = lib.mkOption {
        type = lib.types.str;
        default = "immich.${config.serviceSettings.domain}";
        description = "Route the service should be accessible at (requires traefik)";
      };
    };
  };

  config = {
    # Mount app-specific network shares
    fileSystems."/mnt/vault" = {
      device = "${config.serviceSettings.nasIp}:/mnt/storage0/vault";
      fsType = "nfs";
    };

    services.immich = {
      enable = true;
      inherit port;
    };

    # Register service to reverse proxy
    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable (
      traefik-utils.generateBasicTraefikEntry {
        service = "immich";
        url = config.serviceSettings.immich.url;
        internal = "http://${config.services.immich.host}:${builtins.toString config.services.immich.port}";
      }
    );
  };
}
