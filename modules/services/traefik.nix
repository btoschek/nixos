{
  den,
  lib,
  ...
}: let
  dataDir = "/var/lib/traefik";
  domain = "homelab.btoschek.org";
in {
  # Declare routes with simplified generic options
  den.quirks.routes = {
    description = "Route declarations used by reverse-proxy";
  };

  # Extend routes and auto-generate missing information
  den.policies.extend-routes = {host, ...}: let
    inherit (den.lib.policy) pipe;
  in [
    (pipe.from "routes" [
      (pipe.transform (r: let
        fqdn = "${r.subdomain}.${domain}";
      in
        #assert _ -> r.port != null;
        #assert _ -> r.subdomain != null;
        r
        // lib.optionalAttrs (!(r ? "fqdn")) {inherit fqdn;}
        // lib.optionalAttrs (!(r ? "url")) {url = "https://${fqdn}";}
        // lib.optionalAttrs (!(r ? "internal")) {internal = "127.0.0.1:${builtins.toString r.port}";}))
    ])
  ];

  # Automatically include policy for all hosts
  den.default.includes = [den.policies.extend-routes];

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

        dynamicConfigOptions = {
          http = {
            routers =
              builtins.listToAttrs (builtins.map (r: {
                  name = "${r.service}-router";
                  value = {
                    entryPoints = ["websecure"];
                    rule = "Host(`${r.fqdn}`)";
                    service = "${r.service}@local";
                  };
                })
                routes)
              // {
                "traefik-dashboard" = {
                  entryPoints = ["websecure"];
                  rule = "Host(`traefik.${domain}`)";
                  service = "api@internal";
                };
              };

            services = builtins.listToAttrs (builtins.map (r: {
                name = "${r.service}@local";
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

    persist.directories = [
      dataDir
    ];
  };
}
