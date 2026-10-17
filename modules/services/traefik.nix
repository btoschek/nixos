{
  den,
  lib,
  ...
}: let
  dataDir = "/var/lib/traefik";
in {
  den.aspects.services.provides.traefik = {
    nixos = {
      host,
      routes,
      config,
      ...
    }: {
      networking.firewall.allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];

      sops.secrets = {
        "cloudflare/api-token" = {
          mode = "0440";
          group = config.services.traefik.group;
        };
      };

      services.traefik = {
        enable = true;

        inherit dataDir;

        # NOTE: Apparently, traefik only reads the env files listed here, so we have to
        #       create an additional file pointing to our actual token file (created by sops-nix)
        environmentFiles = [
          (builtins.toFile "traefik.env" ''
            CF_DNS_API_TOKEN_FILE="${config.sops.secrets."cloudflare/api-token".path}"
          '')
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
                certResolver = "production";
                domains = [
                  {
                    main = host.domain;
                    sans = ["*.${host.domain}"];
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

          certificatesResolvers = {
            production = {
              acme = {
                storage = "${dataDir}/acme.json";
                dnsChallenge = {
                  provider = "cloudflare";
                  resolvers = [
                    "1.1.1.1:53"
                    "8.8.8.8:53"
                  ];
                };
              };
            };

            staging = {
              acme = {
                storage = "${dataDir}/acme-staging.json";
                caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
                dnsChallenge = {
                  provider = "cloudflare";
                  resolvers = [
                    "1.1.1.1:53"
                    "8.8.8.8:53"
                  ];
                };
              };
            };
          };

          # TODO: Bring Traefik dashboard behind auth middleware
          api = {
            dashboard = true;
            insecure = false;
          };
        };

        dynamicConfigOptions = {
          http = {
            routers =
              builtins.listToAttrs (builtins.map (r: {
                  name = "${r.service}-router";
                  value = {
                    entryPoints = ["websecure"];
                    rule = "Host(`${r.fqdn}`)";
                    inherit (r) service;
                  };
                })
                routes)
              // {
                "traefik-dashboard" = {
                  entryPoints = ["websecure"];
                  rule = "Host(`traefik.${host.domain}`)";
                  service = "api@internal";
                };
              };

            services = builtins.listToAttrs (builtins.map (r: {
                name = r.service;
                value = {
                  loadBalancer.servers = [
                    {url = r.internal;}
                  ];
                };
              })
              routes);
          };
        };
      };
    };

    persist-directories = [
      dataDir
    ];
  };
}
