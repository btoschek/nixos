{
  den,
  lib,
  ...
}: let
  dataDir = "/var/lib/traefik";
  domain = "homelab.btoschek.org";
in {
  den.quirks.routes = {
    description = "Route declarations used by reverse-proxy";
  };

  den.aspects.services.provides.traefik = {
    nixos = {routes, ...}: {
      # TODO: Add sops option
      #secrets = {
      #  "cloudflare/api-token" = {
      #    mode = "0440";
      #    #group = config.services.traefik.group;
      #  };
      #};

      services.traefik = {
        enable = true;

        inherit dataDir;

        # NOTE: Apparently, traefik only reads the env files listed here, so we have to
        #       create an additional file pointing to our actual token file (created by sops-nix)
        environmentFiles = [
          #(builtins.toFile "traefik_env.env" ''
          #  CF_DNS_API_TOKEN_FILE="${config.sops.secrets."cloudflare/api-token".path}"
          #'')
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
              http.tls = {
                certResolver = "letsencrypt";
                domains = [
                  {
                    main = domain;
                    sans = ["*.${domain}"];
                  }
                ];
              };
            };
          };

          log = {
            level = "INFO";
            filePath = "${dataDir}/traefik.log";
            format = "json";
          };

          certificatesResolvers.letsencrypt.acme = {
            storage = "${dataDir}/acme.json";
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

          # TODO: Bring Traefik dashboard behind auth middleware
          api = {
            dashboard = true;
            insecure = false;
          };
        };

        # Use SSL encryption for dashboard endpoint
        dynamicConfigOptions = {
          http =
            #{
            #  routers."traefik-dashboard" = {
            #    entryPoints = ["websecure"];
            #    rule = "Host(`traefik.${domain}`)";
            #    service = "api@internal";
            #  };
            #}
            #//
            builtins.foldl' (acc: entry: let
              service = builtins.elemAt (builtins.attrNames entry) 0;
              conf = entry.${service};
            in
              acc
              // {
                routers =
                  (acc.routers or {})
                  // {
                    "${service}-router" = {
                      entryPoints = ["websecure"];
                      rule = "Host(`${conf.subdomain}.${domain}`)";
                      inherit service;
                    };
                  };

                services =
                  (acc.services or {})
                  // {
                    "${service}".loadBalancer.servers = [
                      {url = "127.0.0.1:${builtins.toString conf.port}";}
                    ];
                  };
              })
            {}
            routes;
        };
      };
    };

    persist.directories = [
      dataDir
    ];
  };
}
