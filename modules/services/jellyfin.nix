{
  config,
  lib,
  ...
}: let
  cfg = config.serviceSettings.jellyfin;
  traefik-utils = import ./traefik/utils.nix;
in {
  options = {
    serviceSettings.jellyfin = {
      enable = lib.mkEnableOption "Enable jellyfin";

      url = lib.mkOption {
        type = lib.types.str;
        default = "jellyfin.${config.serviceSettings.domain}";
        description = "URL the service should be accessible at (requires traefik)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Mount network share (media gallery)
    fileSystems."/mnt/jellyfin/media" = {
      device = "${config.serviceSettings.nasIp}:/mnt/storage0/media";
      fsType = "nfs";
    };

    services.jellyfin = {
      enable = true;
    };

    # Register service to reverse proxy
    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable (
      traefik-utils.generateBasicTraefikEntry {
        service = "jellyfin";
        url = cfg.url;
        internal = "http://localhost:8096";
      }
    );

    # Retain program data across reboots
    environment.persistence."/persist" = {
      directories = [
        config.services.jellyfin.dataDir
      ];
    };
  };
}
