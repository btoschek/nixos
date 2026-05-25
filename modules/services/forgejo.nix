{den, ...}: {
  den.aspects.services.provides.forgejo = let
    port = 3000;
    stateDir = "/var/lib/forgejo";
  in {
    nixos = {config, ...}: {
      services.forgejo = {
        enable = true;
        inherit stateDir;

        settings = {
          session.COOKIE_SECURE = config.services.traefik.enable;

          server = {
            #SSH_PORT = #TODO;
            #DOMAIN = cfg.url;
            HTTP_PORT = port;
            #ROOT_URL = "https://${cfg.url}";
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
    };

    persist.directories = [
      stateDir
    ];

    routes = {
      service = "forgejo";
      subdomain = "git";
      inherit port;
    };
  };
}
