{den, ...}: {
  den.aspects.services.provides.forgejo = let
    port = 3000;
    ssh_port = 2222;
    stateDir = "/var/lib/forgejo";
  in {
    nixos = {
      host,
      config,
      ...
    }: {
      # NOTE: Works for now, bring this behind traefik
      networking.firewall.allowedTCPPorts = [
        ssh_port
      ];

      services.forgejo = {
        enable = true;
        inherit stateDir;

        settings = {
          session.COOKIE_SECURE = config.services.traefik.enable;

          DEFAULT = {
            APP_NAME = "Homelab git";
            APP_SLOGAN = "Don't fuel Microsoft's delusion";
          };

          repository = {
            DEFAULT_BRANCH = "main";
          };

          server = {
            SSH_PORT = ssh_port;
            HTTP_PORT = port;
            ROOT_URL = "https://git.${host.domain}"; # TODO: Get from routes quirk
            START_SSH_SERVER = true;
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

    persist-directories = [
      stateDir
    ];

    routes = {
      service = "forgejo";
      subdomain = "git";
      inherit port;
    };
  };
}
