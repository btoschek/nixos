{
  config,
  lib,
  ...
}: let
  cfg = config.serviceSettings.forgejo;
  traefik-utils = import ./traefik/utils.nix;
in {
  options = {
    serviceSettings.forgejo = {
      enable = lib.mkEnableOption "Enable forgejo";

      url = lib.mkOption {
        type = lib.types.str;
        default = "git.${config.systemSettings.domain}";
        description = "URL the service should be accessible at (requires traefik)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # ===============================================
    #  Service config
    # ===============================================

    services.forgejo = {
      enable = true;
      settings = {
        session.COOKIE_SECURE = config.serviceSettings.traefik.enable;

        server = {
          #SSH_PORT = #TODO;
          DOMAIN = cfg.url;
          ROOT_URL = "https://${cfg.url}";
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };

        # NOTE: Temporary set this to `false` to enable creation of an admin user
        service.DISABLE_REGISTRATION = true;
      };
      database.type = "sqlite3";
      lfs.enable = true;
    };

    # ===============================================
    #  Persistence / impermanence
    # ===============================================

    # Retain program data across reboots
    environment.persistence."${config.systemSettings.impermanence.mountPoint}" = {
      directories = [
        config.services.forgejo.stateDir
      ];
    };

    # ===============================================
    #  Routing
    # ===============================================

    # Register service to reverse proxy
    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable (
      traefik-utils.generateBasicTraefikEntry {
        service = "forgejo";
        url = cfg.url;
        internal = "http://localhost:${builtins.toString config.services.forgejo.settings.server.HTTP_PORT}";
      }
    );
  };
}
