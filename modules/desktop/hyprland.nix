{
  den,
  lib,
  ...
}: {
  den.aspects.gui = {
    # TODO: Is this even needed?
    nixos = {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        libnotify

        grim
        slurp

        awww
        eww

        # TODO: Check, why both
        wl-clipboard
        copyq
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
        xwayland.enable = true;

        configType = "lua";

        settings = let
          monitor0 = "DP-1";
          monitor1 = "DP-2";
          mod = "SUPER";
        in {
          # Explicitly setup both WQHD monitors
          # Enable fallback for undefined ports
          monitor = [
            {
              output = monitor0;
              mode = "2560x1440@165";
              position = "0x0";
              scale = 1;
            }
            {
              output = monitor1;
              mode = "2560x1440@165";
              position = "2560x0";
              scale = 1;
            }
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = 1;
            }
          ];

          on = {
            # Background processes
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("dunst")                       -- Notification daemon
                  hl.exec_cmd("awww-daemon && eww daemon")   -- Wallpaper daemon & Widgets
                  hl.exec_cmd("eww open wallpaper_time")     -- Open wallpaper time overlay
                  hl.exec_cmd("copyq --start-server")        -- Clipboard manager
                end
              '')
            ];
          };

          config = {
            general = {
              gaps_in = 5; # Gaps between windows
              gaps_out = 10; # Gaps between windows and monitor edge
              border_size = 2; # Size of the border around windows

              # NOTE: Those are currently being set by stylix
              #          "col.active_border" = "rgba(7aa2f7ee) rgba(f7768eee) 30deg";  # Border color of active windows
              #          "col.inactive_border" = "rgba(595959aa)";                     # Border color of inactive windows

              layout = "dwindle"; # Default layout to use ("dwindle" | "master")
              hover_icon_on_border = false;
            };

            decoration = {
              rounding = 5; # Rounded window corners
              dim_modal = false; # Don't allow parent windows dimming out their own popup windows
              blur = {
                enabled = true; # Enable blurring of window backgrounds (kawase)
                size = 8; # Blur size (distance)
                passes = 1; # Amount of passes
                new_optimizations = true; # Enable optimizations
              };
            };

            animations = {
              enabled = true;
            };

            input = {
              # Keyboard
              kb_layout = "de"; # Base layout
              kb_variant = ""; # Variant (differing keys from base layout, e.g. colemak_dh)
              kb_model = ""; # Model (e.g. pc86, logitech_base, ...)
              kb_options = ""; # Options (japanese, euro sign position, ...)
              kb_rules = "";

              # Mouse
              sensitivity = 0; # Keep mouse sensitivity at default (-1.0 to 1.0)
              follow_mouse = 2; # Click another window to relocate focus to it
              mouse_refocus = true; # Focus overlay windows on mouse move
            };

            misc = {
              disable_hyprland_logo = true; # Disable default Anime girl background
              disable_splash_rendering = true; # Disable splash text
              animate_manual_resizes = true; # Play a small animation when resizing manually
              on_focus_under_fullscreen = 2; # Disable current fullscreen when opening a new window
              vrr = 3; # Allow adaptive sync for fullscreen apps with `video` or `game` content type
            };

            render = {
              direct_scanout = 2; # Reduce lag for apps with content type `game`
              cm_auto_hdr = 1; # Switch to fullscreen HDR if needed
            };

            cursor = {
              sync_gsettings_theme = true; # Sync xcursor theme with gsettings (GTK apps)
              enable_hyprcursor = true; # Enable hyprcursor support
            };

            ecosystem = {
              no_update_news = true; # Disable popup after wm update
              no_donation_nag = true; # Disable popup with wm donation request
            };

            # Dwindle layout
            dwindle = {
              force_split = 2; # Always split to the right / below
              preserve_split = true; # Keep split regardless of what happens to the container
            };
          };

          curve = [
            {
              _args = [
                "myBezier"
                (lib.generators.mkLuaInline "{type = \"bezier\", points = { {0.05, 0.9}, {0.1, 1.05} }}")
              ];
            }
          ];

          animation = [
            {
              leaf = "windows";
              enabled = true;
              speed = 7;
              bezier = "myBezier";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 7;
              bezier = "default";
              style = "popin 80%";
            }
            {
              leaf = "border";
              enabled = true;
              speed = 10;
              bezier = "default";
            }
            {
              leaf = "borderangle";
              enabled = true;
              speed = 8;
              bezier = "default";
            }
            {
              leaf = "fade";
              enabled = true;
              speed = 7;
              bezier = "default";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 6;
              bezier = "default";
            }
          ];

          # Dedicate workspaces to monitors
          workspace_rule = [
            {
              workspace = 1;
              monitor = monitor0;
            }
            {
              workspace = 2;
              monitor = monitor0;
            }
            {
              workspace = 3;
              monitor = monitor1;
              default_name = "Browser";
            }
            {
              workspace = 4;
              monitor = monitor1;
              default_name = "Multimedia";
            }
            {
              workspace = 5;
              monitor = monitor1;
              default_name = "Launchers";
            }
            {
              workspace = 10;
              monitor = monitor0;
              default_name = "Games";
            }
          ];

          window_rule = [
            {
              name = "Visualize current working state of terminal windows";
              match.class = "^(kitty)$";
              opacity = "0.9 override 0.7 override";
            }

            # == Gaming ====================================================

            {
              name = "Automatically open Steam-related windows on dedicated launcher workspace";
              match.class = "^(steam)$";
              workspace = "name:Launchers silent";
            }
            #{
            #  name = "Automatically open Prism launcher (Minecraft) on dedicated launcher workspace";
            #  match.class = "org.prismlauncher.PrismLauncher";
            #  workspace = "name:5 silent";
            #}
            {
              name = "Float Steam screenshot manager";
              match = {
                class = "^(steam)$";
                title = "^(Screenshot Manager)$";
              };
              float = true;
            }
            {
              name = "Float Steam friends list";
              match = {
                class = "^(steam)$";
                title = "^(Friends List)$";
              };
              float = true;
            }
            {
              name = "Steam Games";
              match.initial_class = "^steam_app_\\d+$";
              workspace = "10 silent";
              content = "game";
              rounding = 0;
            }
            {
              name = "GregTech: New Horizons";
              match.class = "^(GT\\:\\ New Horizons)(.*)$";
              workspace = "10 silent";
              content = "game";
            }

            # == Default workspace assignments =============================

            {
              name = "Automatically open spotify on multimedia workspace";
              match.class = "^(Spotify)$";
              workspace = "4 silent"; # NOTE: Why does "Multimedia" not work here, dafuq?
            }
            {
              name = "Automatically open discord on multimedia workspace";
              match.class = "^(discord)$";
              workspace = "4 silent"; # NOTE: Why does "Multimedia" not work here, dafuq?
            }
            {
              name = "Automatically open floorp on Browser workspace";
              match.class = "^(floorp)$";
              workspace = "name:Browser silent";
            }

            {
              name = "Automatically position Picture-in-Picture windows at the bottom right of the screen";
              match.initial_title = "^(Picture-in-Picture)$";
              float = true;
              size = "30% 30%";
              move = "{\"monitor_w-window_w-30\", \"monitor_h-window_h-30\"}";
            }
          ];

          bind =
            [
              {
                _args = [
                  "${mod} + RETURN"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kitty\")")
                  {description = "Open terminal";}
                ];
              }
              {
                _args = [
                  "${mod} + Z"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"kitty -e rmpc\")")
                  {description = "Open local music player (rmpc)";}
                ];
              }
              {
                _args = [
                  "${mod} + SPACE"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"$HOME/.config/rofi/scripts/launcher.sh\")")
                  {description = "Execute application runner";}
                ];
              }
              {
                _args = [
                  "${mod} + C"
                  (lib.generators.mkLuaInline "hl.dsp.window.close()")
                  {description = "Close the currently focused window";}
                ];
              }
              #{
              #  _args = [
              #    "${mod} + V"
              #    (lib.generators.mkLuaInline "hl.dsp.window.float()")  # ???
              #    {description = "Toggle floating behaviour of focused window";}
              #  ];
              #}
              {
                _args = [
                  "${mod} + F"
                  (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({mode = \"maximized\", action = \"toggle\"})")
                  {description = "Fullscreen window (with border)";}
                ];
              }
              {
                _args = [
                  "${mod} + T"
                  (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({mode = \"fullscreen\", action = \"toggle\"})")
                  {description = "Fullscreen window (no border)";}
                ];
              }
              {
                _args = [
                  "${mod} + mouse:272"
                  (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                  {description = "Move window around with the cursor";}
                ];
              }
              {
                _args = [
                  "${mod} + mouse:273"
                  (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                  {description = "Resize window using the cursor";}
                ];
              }
              {
                _args = [
                  "${mod} + S"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"$HOME/.config/hypr/scripts/screenshot.sh area\")")
                  {description = "Screenshot specific area";}
                ];
              }
              {
                _args = [
                  "${mod} + N"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"$(eww get EWW_CONFIG_DIR)/scripts/toggle_popup sidebar\")")
                  {description = "Toggle sidebar";}
                ];
              }

              # Vim motions
              {
                _args = [
                  "${mod} + H"
                  (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"l\"})")
                  {description = "Move focus to the left";}
                ];
              }
              {
                _args = [
                  "${mod} + L"
                  (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"r\"})")
                  {description = "Move focus to the right";}
                ];
              }
              {
                _args = [
                  "${mod} + K"
                  (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"u\"})")
                  {description = "Move focus up";}
                ];
              }
              {
                _args = [
                  "${mod} + J"
                  (lib.generators.mkLuaInline "hl.dsp.focus({direction = \"d\"})")
                  {description = "Move focus down";}
                ];
              }

              # Move current workspace to different monitor

              #{
              #  _args = [
              #    "${mod} + SHIFT + LEFT"
              #    (lib.generators.mkLuaInline "hl.dsp.workspace.move({direction = \"d\"})")
              #    {description = "Move focus down";}
              #  ];
              #}

              # Audio controls
              # NOTE: Close spotify to control mpd

              {
                _args = [
                  "XF86AudioPlay"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl -p spotify,mpd play-pause\")")
                  {description = "Play / pause music";}
                ];
              }
              {
                _args = [
                  "XF86AudioNext"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl -p spotify,mpd next\")")
                  {description = "Skip current music track";}
                ];
              }
              {
                _args = [
                  "XF86AudioPrev"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl -p spotify,mpd previous\")")
                  {description = "Skip back one music track";}
                ];
              }
              {
                _args = [
                  "XF86AudioRaiseVolume"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl -p spotify,mpd volume 0.05+\")")
                  {
                    description = "Increase music volume";
                    locked = true;
                    repeating = true;
                  }
                ];
              }
              {
                _args = [
                  "XF86AudioLowerVolume"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl -p spotify,mpd volume 0.05-\")")
                  {
                    description = "Decrease music volume";
                    locked = true;
                    repeating = true;
                  }
                ];
              }

              # Testing: Get information about currently selected window
              {
                _args = [
                  "${mod} + I"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd('notify-send \"Active window:\" \"`hyprctl activewindow`\"')")
                  {description = "Show information about currently focused window";}
                ];
              }
            ]
            ++ (
              # Switch/[move window] to workspace with $mod[+ Shift] + number
              builtins.concatLists (builtins.genList (
                  i: let
                    ws =
                      if i == 0
                      then 10
                      else i;
                  in [
                    {
                      _args = [
                        "${mod} + ${toString i}"
                        (lib.generators.mkLuaInline "hl.dsp.focus({workspace = ${toString ws}})")
                        {description = "Focus workspace ${toString ws}";}
                      ];
                    }
                    #"$mod SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
                  ]
                )
                10)
            );
        };
      };
    };
  };
}
