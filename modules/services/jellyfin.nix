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

      # NOTE: Changing this currently has no effect
      port = lib.mkOption {
        type = lib.types.int;
        default = 8096;
        description = "Port the service is reachable at (if used with reverse proxy: internal only)";
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
        inherit (cfg) url;
        internal = "http://127.0.0.1:${builtins.toString cfg.port}";
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
