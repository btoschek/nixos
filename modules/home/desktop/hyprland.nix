{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    hyprcursor.enable = true;
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;

    settings = {
      "$monitor0" = "DP-1";
      "$monitor1" = "DP-2";

      # Explicitly setup both WQHD monitors
      # Enable fallback for undefined ports
      monitor = [
        "$monitor0, 2560x1440@165, 0x0, 1"
        "$monitor1, 2560x1440@165, 2560x0, 1"
        " , preferred, auto, 1"
      ];

      # Background processes
      exec-once = [
        "dunst"                                                       # Notification daemon
        "swww-daemon && eww daemon"                                   # Wallpaper daemon & Widgets
        "eww open wallpaper_time"                                     # Open wallpaper time overlay
        "copyq --start-server"                                        # Clipboard manager
      ];

      input = {
        # Keyboard
        kb_layout = "de";                                             # Base layout
        kb_variant = "";                                              # Variant (differing keys from base layout, e.g. colemak_dh)
        kb_model = "";                                                # Model (e.g. pc86, logitech_base, ...)
        kb_options = "";                                              # Options (japanese, euro sign position, ...)
        kb_rules = "";

        # Mouse
        sensitivity = 0;                                              # Keep mouse sensitivity at default (-1.0 to 1.0)
        follow_mouse = 2;                                             # Click another window to relocate focus to it
        mouse_refocus = true;                                         # Focus overlay windows on mouse move
      };

      general = {
        gaps_in = 5;                                                  # Gaps between windows
        gaps_out = 10;                                                # Gaps between windows and monitor edge
        border_size = 2;                                              # Size of the border around windows

        "col.active_border" = "rgba(7aa2f7ee) rgba(f7768eee) 30deg";  # Border color of active windows
        "col.inactive_border" = "rgba(595959aa)";                     # Border color of inactive windows

        layout = "dwindle";                                           # Default layout to use ("dwindle" | "master")
      };

      misc = {
        disable_hyprland_logo = true;                                 # Disable default Anime girl background
        disable_splash_rendering = true;                              # Disable splash text
        animate_manual_resizes = true;                                # Play a small animation when resizing manually
        new_window_takes_over_fullscreen = 2;                         # Disable current fullscreen when opening a new window
      };

      ecosystem = {
        no_update_news = true;                                        # Disable popup after wm update
        no_donation_nag = true;                                       # Disable popup with wm donation request
      };

      decoration = {
        rounding = 5;                                                 # Rounded window corners
        blur = {
          enabled = true;                                             # Enable blurring of window backgrounds (kawase)
          size = 8;                                                   # Blur size (distance)
          passes = 1;                                                 # Amount of passes
          new_optimizations = true;                                   # Enable optimizations
        };
      };

      cursor = {
        sync_gsettings_theme = true;                                  # Sync xcursor theme with gsettings (GTK apps)
        enable_hyprcursor = true;                                     # Enable hyprcursor support
      };

      render.direct_scanout = 2;                                      # Reduce lag for fullscreen games

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          # NAME, ONOFF, SPEED, CURVE [, STYLE]
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;                                            # Pseudotiled windows retain size when tiled
        force_split = 2;                                              # Always split to the right / below
        preserve_split = true;                                        # Keep split regardless of what happens to the container
      };

      # Dedicate workspaces to monitors
      workspace = [
        "1 , monitor:$monitor0"
        "2 , monitor:$monitor0"
        "3 , monitor:$monitor1"
        "4 , monitor:$monitor1"
        "5 , monitor:$monitor1"
        "10, monitor:$monitor0"
      ];

      windowrulev2 = [
        # Terminal
        "opacity 0.9 override 0.7 override, class:^(kitty)$"

        # Steam
        "workspace 5 silent, class:^(steam)$"
        "float, class:^(steam)$, title:^(Screenshot Manager)$"
        "float, class:^(steam)$, title:^(Friends List)$"

        # Games
        "workspace 10 silent, initialclass:^steam_app_\\d+$"
        "content game, initialclass:^steam_app_\\d+$"
        "rounding 0, initialclass:^steam_app_\\d+$"

        "workspace 10 silent, class:^(GT\\:\\ New Horizons)(.*)$"
        "content game, class:^(GT\\:\\ New Horizons)(.*)$"

        # Workspace 4: Multimedia / Communication
        "workspace 4 silent, class:^(spotify)$"
        "workspace 4 silent, class:^(discord)$"

        # Workspace 3: Browsers
        "workspace 3 silent, class:^(firefox)$"
        "workspace 3 silent, class:^(org.qutebrowser.qutebrowser)$"
        "workspace 3 silent, class:^(zen)$"

        "float, initialtitle:^(Picture-in-Picture)$"
        "size 30% 30%, initialtitle:^(Picture-in-Picture)$"
        "move 100%-w-30 100%-w-30, initialtitle:^(Picture-in-Picture)$"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"

        "$mod, C    , killactive,"                                    # Kill the currently focused window
        "$mod, V    , togglefloating,"                                # Toggle floating behaviour for focused window
        "$mod, Space, exec, $HOME/.config/rofi/scripts/launcher.sh"   # Execute application runner
        "$mod, P    , pseudo,"                                        # Change tiling to use pseudo mode
        "$mod, F    , fullscreen, 1"                                  # Fullscreen window (with border)
        "$mod, T    , fullscreen, 0"                                  # Fullscreen window (no border)
        "$mod, B    , togglesplit,"                                   # Rotate split orientation

        # Screenshot
        "$mod, s, exec, $HOME/.config/hypr/scripts/screenshot.sh area"

        # Toggle sidebar
        "$mod, n, exec, $(eww get EWW_CONFIG_DIR)/scripts/toggle_popup sidebar"

        # Move focus with $mod + vim bindings
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move current workspace to different monitor
        "$mod SHIFT, LEFT, movecurrentworkspacetomonitor, l"
        "$mod SHIFT, RIGHT, movecurrentworkspacetomonitor, r"
        "$mod SHIFT, UP, movecurrentworkspacetomonitor, l"
        "$mod SHIFT, DOWN, movecurrentworkspacetomonitor, r"

        # Scroll through existing workspaces with $mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up  , workspace, e-1"

        # Audio controls
        " , XF86AudioPlay , exec, playerctl -p spotify play-pause"
        " , XF86AudioNext , exec, playerctl -p spotify next"
        " , XF86AudioPrev , exec, playerctl -p spotify previous"

        # Testing: Get information about currently selected window
        "$mod, I, exec, notify-send \"Active window:\" \"`hyprctl activewindow`\""
      ]
      ++ (
        # Switch/[move window] to workspace with $mod[+ Shift] + number
        builtins.concatLists (builtins.genList (i:
            let ws = if i == 0 then 10 else i;
            in [
              "$mod, ${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          10)
      );

      # Mouse bindings
      bindm = [
        # Move / resize window with $mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Repeating when held
      binde = [
        " , XF86AudioRaiseVolume, exec, playerctl -p spotify volume 0.05+"
        " , XF86AudioLowerVolume, exec, playerctl -p spotify volume 0.05-"
      ];
    };
  };
}
