{
  config,
  lib,
  ...
}: let
  cfg = config.serviceSettings.traefik;
  traefik_env = builtins.toFile "traefik_env.env" ''
    CF_DNS_API_TOKEN_FILE="${config.sops.secrets."cloudflare/api-token".path}"
  '';
in {
  options = {
    serviceSettings.traefik = {
      enable = lib.mkEnableOption "Enable traefik";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "cloudflare/api-token" = {
        mode = "0440";
        group = config.services.traefik.group;
      };
    };

    services.traefik = {
      enable = true;

      # NOTE: Apparently, traefik only reads the env files listed here, so we have to
      #       create an additional file pointing to our actual token file (created by sops-nix)
      environmentFiles = [
        traefik_env
      ];

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
          storage = "${config.services.traefik.dataDir}/acme.json";
          # NOTE: Staging url, remove to request actual certs
          # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
          dnsChallenge = {
            provider = "cloudflare";
            resolvers = [
              "1.1.1.1:53"
              "8.8.8.8:53"
            ];
          };
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
