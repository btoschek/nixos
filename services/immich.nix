{ config, lib, ... }:

let
  cfg = config.serviceSettings.immich;
  port = 2283;
in
{
  options = {
    serviceSettings.immich = {
      enable = lib.mkEnableOption "Enable immich";
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

    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable {
      http = {
        routers = {
          immich-router = {
            entryPoints = [ "websecure" ];
            rule = "Host(`immich.${config.serviceSettings.domain}`)";
            service = "immich";
          };
        };

        services = {
          immich.loadBalancer.servers = [
            { url = "http://localhost:${builtins.toString port}"; }
          ];
        };
      };
    };
  };
}
