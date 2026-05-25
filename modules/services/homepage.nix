{
  den,
  lib,
  ...
}: {
  den.aspects.services.provides.homepage = let
    port = 8082;
  in {
    nixos = {
      pkgs,
      routes,
      ...
    }: let
      background = pkgs.fetchurl {
        name = "homepage-background.jpg";
        url = "https://images.hdqwalls.com/wallpapers/airplane-dawn-dusk-flight-sunrise-sky-24.jpg";
        hash = "sha256-h2nlNsH5WoZP8y4e+EGzg87DM6bEOftegeRIK+AvT3o=";
      };

      package = pkgs.homepage-dashboard.overrideAttrs (oldAttrs: {
        postInstall = ''
          mkdir -p $out/share/homepage/public/images
          ln -s ${background} $out/share/homepage/public/images/background.jpg
        '';
      });
    in {
      services.homepage-dashboard = {
        enable = true;
        inherit package;

        listenPort = port;

        # TODO: Figure this thing out
        allowedHosts = "*";

        settings = {
          title = "Dashboard";
          headerStyle = "clean";
          statusStyle = "basic";
          background = {
            image = "/images/background.jpg";
            opacity = 60;
          };
          layout = {
            Media = {
              style = "row";
              columns = 4;
            };
            Development = {
              style = "row";
              columns = 4;
            };
            "All-day life" = {
              style = "row";
              columns = 4;
            };
          };
        };

        widgets = [
          {
            resources = {
              cpu = true;
              disk = "/";
              memory = true;
            };
          }
          {
            openmeteo = {
              label = "Wertheim";
              latitude = "49.759";
              longitude = "9.5085";
              timezone = "Europe/Berlin";
              units = "metric";
              cache = 5;
            };
          }
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
        ];

        services = let
          # Get set of configured services based on 'routes' quirk
          configured_services = builtins.listToAttrs (builtins.map (r: {
              name = r.service;
              value = r;
            })
            routes);
        in [
          {
            Media =
              (lib.lists.optionals (configured_services ? "immich") [
                {
                  Immich = {
                    description = "Image gallery";
                    icon = "immich.svg";
                    href = configured_services.immich.url;
                    siteMonitor = configured_services.immich.internal;
                  };
                }
              ])
              ++ (lib.lists.optionals (configured_services ? "jellyfin") [
                {
                  Jellyfin = {
                    description = "Movies & Series";
                    icon = "jellyfin.svg";
                    href = configured_services.jellyfin.url;
                    siteMonitor = configured_services.jellyfin.internal;
                  };
                }
              ])
              ++ (lib.lists.optionals (configured_services ? "kavita") [
                {
                  Kavita = {
                    description = "Manga reader";
                    icon = "kavita.svg";
                    href = configured_services.kavita.url;
                    siteMonitor = configured_services.kavita.internal;
                  };
                }
              ]);
          }
          {
            Development = lib.lists.optionals (configured_services ? "forgejo") [
              {
                Forgejo = {
                  description = "Git forge";
                  icon = "forgejo.svg";
                  href = configured_services.forgejo.url;
                  siteMonitor = configured_services.forgejo.internal;
                };
              }
            ];
          }
          {
            "All-day life" = [
              {
                HomeAssistant = {
                  description = "Smart home coordinator";
                  icon = "home-assistant.svg";
                  href = "http://192.168.101.100:8123";
                };
              }
              {
                "Ender 3 Pro" = {
                  description = "3D Printer";
                  icon = "mainsail.svg";
                  href = "http://192.168.100.50";
                };
              }
            ];
          }
        ];

        bookmarks = [
          {
            Tech = [
              {
                GitHub = [
                  {
                    icon = "github.svg";
                    href = "https://github.com/";
                  }
                ];
              }
            ];
          }
          {
            Social = [
              {
                Reddit = [
                  {
                    icon = "reddit.svg";
                    href = "https://reddit.com/";
                  }
                ];
              }
            ];
          }
          {
            Entertainment = [
              {
                YouTube = [
                  {
                    icon = "youtube.svg";
                    href = "https://youtube.com/";
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    routes = {host, ...}: {
      service = "homepage";
      subdomain = "";
      # NOTE: Explicitly declare access to service via root domain (as "landing page")
      fqdn = host.domain;
      inherit port;
    };
  };
}
