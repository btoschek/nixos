{den, ...}: {
  den.aspects.gaming = {
    includes = [
      (den.provides.unfree [
        "steam"
        "steam-unwrapped"
      ])
    ];

    nixos = {pkgs, ...}: {
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
          };
        };
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      hardware.bluetooth = {
        settings.General = {
          # Show battery
          Experimental = true;

          # Support for pairing controllers
          Class = "0x000100";
          FastConnectable = true;
          Privacy = "device";
          JustWorksRepairing = "always";
        };

        settings.LE = {
          MinConnectionInterval = 7;
          MaxConnectionInterval = 9;
          ConnectionLatency = 0;
        };
      };

      # TODO: Only configure if bluetooth enabled
      # Driver for Xbox One wireless controllers
      hardware.xpadneo.enable = true;
    };

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        gamescope
        prismlauncher
        heroic
        protonup-rs
      ];

      programs.mangohud = {
        enable = true;
        settings = {
          toggle_hud = "F10";
          gpu_temp = true;
          cpu_temp = true;
          no_display = true;
        };
      };
    };
  };
}
