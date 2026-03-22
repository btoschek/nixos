{
  config,
  lib,
  ...
}: let
  cfg = config.serviceSettings.immich;
  traefik-utils = import ./traefik/utils.nix;
in {
  options = {
    serviceSettings.immich = {
      enable = lib.mkEnableOption "Enable immich";

      url = lib.mkOption {
        type = lib.types.str;
        default = "immich.${config.systemSettings.domain}";
        description = "URL the service should be accessible at (requires traefik)";
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 2283;
        description = "Port the service is reachable at (if used with reverse proxy: internal only)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Mount app-specific network shares
    fileSystems."/mnt/vault" = {
      device = "${config.systemSettings.nasIp}:/mnt/storage0/vault";
      fsType = "nfs";
    };

    services.immich = {
      enable = true;
      inherit (cfg) port;
    };

    # Retain program data across reboots
    environment.persistence."${config.systemSettings.impermanence.mountPoint}" = {
      directories = [
        config.services.immich.mediaLocation

        # NOTE: This directory is needed as immich uses Postgres under the hood
        # WARN: As this directory is versioned ("/var/lib/postgresql/<version>"),
        #       always do a backup before bumping versions to avoid data loss
        config.services.postgresql.dataDir
      ];
    };

    # Register service to reverse proxy
    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable (
      traefik-utils.generateBasicTraefikEntry {
        service = "immich";
        inherit (cfg) url;
        internal = "http://127.0.0.1:${builtins.toString cfg.port}";
      }
    );
  };
}
