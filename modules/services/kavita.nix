{den, ...}: {
  den.aspects.services.provides.kavita = let
    port = 5000;
  in {
    nixos = {config, ...}: {
      sops.secrets = {
        "services/kavita/token-key" = {
          mode = "0440";
          owner = config.services.kavita.user;
          group = config.services.kavita.user;
        };
      };

      services.kavita = {
        enable = true;
        tokenKeyFile = config.sops.secrets."services/kavita/token-key".path;
        settings.Port = port;
      };
    };

    persist-directories = {config, ...}: [
      {
        directory = config.services.kavita.dataDir;
        user = config.services.kavita.user;
        group = config.services.kavita.user;
        mode = "0700";
      }
    ];

    routes = {
      service = "kavita";
      subdomain = "kavita";
      inherit port;
    };
  };
}
