{den, ...}: {
  den.aspects.services.provides.forgejo = {
    nixos = {config, ...}: {
      services.forgejo = {
        enable = true;
        settings = {
          session.COOKIE_SECURE = true; # config.serviceSettings.traefik.enable;

          server = {
            #SSH_PORT = #TODO;
            #DOMAIN = cfg.url;
            #HTTP_PORT = cfg.port;
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

    persist.directories = {config, ...}: [
      config.services.forgejo.stateDir
    ];

    routes = {
      service = "forgejo";
      subdomain = "git";
      port = 3000;
    };
  };
}
