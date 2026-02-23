{
  config,
  lib,
  ...
}: let
  cfg = config.serviceSettings.traefik;
in {
  options = {
    serviceSettings.traefik = {
      enable = lib.mkEnableOption "Enable traefik";
    };
  };

  config = lib.mkIf cfg.enable {
    services.traefik = {
      enable = true;

      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
            asDefault = true;
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
            };
          };

          websecure = {
            address = ":443";
            asDefault = true;
            http.tls.certResolver = "letsencrypt";
          };
        };

        log = {
          level = "INFO";
          filePath = "${config.services.traefik.dataDir}/traefik.log";
          format = "json";
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "btoschek@${config.serviceSettings.domain}";
          storage = "${config.services.traefik.dataDir}/acme.json";
          httpChallenge.entryPoint = "web";
        };

        # Access Traefik dashboard for the time being (IP:8080)
        api = {
          dashboard = true;
          insecure = true;
        };
      };
    };
  };
}
