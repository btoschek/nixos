{
  den,
  lib,
  ...
}: {
  den.aspects.services.provides.glance = let
    port = 8080;
  in {
    nixos = {
      routes,
      config,
      ...
    }: {
      services.glance = {
        enable = true;

        settings = {
          server = {
            host = "127.0.0.1";
            inherit port;
            proxied = config.services.traefik.enable;
          };

          branding = {
            hide-footer = true;
          };

          # See: https://github.com/glanceapp/glance/blob/main/docs/themes.md#catppuccin-mocha
          theme = {
            background-color = "240 21 15";
            contrast-multiplier = 1.2;
            primary-color = "217 92 83";
            positive-color = "115 54 76";
            negative-color = "347 70 65";
          };

          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "clock";
                      hour-format = "24h";
                      timezones = [
                        {
                          timezone = "UTC";
                          label = "UTC";
                        }
                      ];
                    }
                    {
                      type = "calendar";
                    }
                    {
                      type = "weather";
                      units = "metric";
                      hour-format = "24h";
                      location = "Wertheim, Germany";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "server-stats";
                      servers = [
                        {
                          type = "local";
                          name = "Beelink Mini S13";
                          hide-mountpoints-by-default = true;
                          mountpoints = {
                            "/persist" = {
                              name = "Persistent data";
                              hide = false;
                            };
                            "/nix/store" = {
                              name = "Nix store";
                              hide = false;
                            };
                          };
                        }
                      ];
                    }
                    {
                      type = "monitor";
                      cache = "1m";
                      title = "Homelab status";
                      sites = let
                        configured_services = builtins.listToAttrs (builtins.map (r: {
                            name = r.service;
                            value = r;
                          })
                          routes);
                      in
                        (lib.lists.optionals (configured_services ? "jellyfin") [
                          {
                            title = "Jellyfin";
                            icon = "sh:jellyfin";
                            url = configured_services.jellyfin.url;
                            check-url = configured_services.jellyfin.internal;
                          }
                        ])
                        ++ (lib.lists.optionals (configured_services ? "immich") [
                          {
                            title = "Immich";
                            icon = "sh:immich";
                            url = configured_services.immich.url;
                            check-url = configured_services.immich.internal;
                          }
                        ])
                        ++ (lib.lists.optionals (configured_services ? "kavita") [
                          {
                            title = "Kavita";
                            icon = "sh:kavita";
                            url = configured_services.kavita.url;
                            check-url = configured_services.kavita.internal;
                          }
                        ])
                        ++ (lib.lists.optionals (configured_services ? "forgejo") [
                          {
                            title = "Forgejo";
                            icon = "sh:forgejo";
                            url = configured_services.forgejo.url;
                            check-url = configured_services.forgejo.internal;
                          }
                        ]);
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "markets";
                      markets = [
                        {
                          symbol = "BTC-USD";
                          name = "Bitcoin";
                        }
                        {
                          symbol = "GC=F";
                          name = "Gold";
                        }
                        {
                          symbol = "SI=F";
                          name = "Silver";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };

    routes = {host, ...}: {
      service = "glance";
      subdomain = "";
      fqdn = host.domain;
      inherit port;
    };
  };
}
