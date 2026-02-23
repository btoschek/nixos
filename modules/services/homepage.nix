{
  config,
  lib,
  pkgs,
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

  cfg = config.serviceSettings.homepage;
  traefik-utils = import ./traefik/utils.nix;
in {
  options = {
    serviceSettings.homepage = {
      enable = lib.mkEnableOption "Enable homepage";

      url = lib.mkOption {
        type = lib.types.str;
        default = config.serviceSettings.domain;
        description = "URL the service should be accessible at (requires traefik)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      inherit package;

      # TODO: Figure this thing out
      allowedHosts = "*";

      settings = {
        title = "Homelab";
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

      services = [
        {
          Media =
            []
            ++ (lib.lists.optionals config.serviceSettings.immich.enable [
              {
                Immich = {
                  description = "Image gallery";
                  icon = "immich.svg";
                  href = "https://${config.serviceSettings.immich.url}/";
                  ping = config.serviceSettings.immich.url;
                };
              }
            ])
            ++ (lib.lists.optionals config.serviceSettings.jellyfin.enable [
              {
                Jellyfin = {
                  description = "Watch local movies and series";
                  icon = "jellyfin.svg";
                  href = "https://${config.serviceSettings.jellyfin.url}/";
                  ping = config.serviceSettings.jellyfin.url;
                };
              }
            ]);
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
          ];
        }
      ];

      bookmarks = [
        {
          Development = [
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

    # Register service to reverse proxy
    services.traefik.dynamicConfigOptions = lib.mkIf config.serviceSettings.traefik.enable (
      traefik-utils.generateBasicTraefikEntry {
        service = "homepage";
        url = config.serviceSettings.homepage.url;
        internal = "http://localhost:${builtins.toString config.services.homepage-dashboard.listenPort}";
      }
    );
  };
}
