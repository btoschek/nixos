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
        default = "jellyfin.${config.systemSettings.domain}";
        description = "URL the service should be accessible at (requires traefik)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # ===============================================
    #  Mounts
    # ===============================================

    # Media gallery
    fileSystems."/mnt/jellyfin/media" = {
      device = "${config.systemSettings.nasIp}:/mnt/storage0/media";
      fsType = "nfs";
    };

    # ===============================================
    #  Service config
    # ===============================================

    services.jellyfin = {
      enable = true;
    };

    # ===============================================
    #  Routing
    # ===============================================

    # Register service to reverse proxy
    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable (
      traefik-utils.generateBasicTraefikEntry {
        service = "jellyfin";
        url = cfg.url;
        internal = "http://localhost:8096";
      }
    );

    # ===============================================
    #  Persistence / impermanence
    # ===============================================

    # Retain program data across reboots
    environment.persistence."${config.systemSettings.impermanence.mountPoint}" = {
      directories = [
        config.services.jellyfin.dataDir
      ];
    };
  };
}
