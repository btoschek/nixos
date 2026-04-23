{den, ...}: {
  den.aspects.btoschek = {
    includes = [
      # Set wheel & networkmanager group
      den.provides.primary-user

      # Set user shell
      (den.provides.user-shell "zsh")

      # TODO: Maybe only include for desktop?
      den.aspects.base
      den.aspects.gui
      den.aspects.gaming
      den.aspects.development
      den.aspects.music
    ];

    user = {...}: {
      description = "User account of btoschek";
      extraGroups = [
        "scanner"
        "lp"
      ];
    };

    homeManager = {pkgs, ...}: {
      home = {
        username = "btoschek";
        homeDirectory = "/home/btoschek";

        packages = [
          # JQ for YAML
          pkgs.yq-go

          pkgs.p7zip
        ];

        programs.eza = {
          enable = true;
          git = true;
        };

        programs.gallery-dl.enable = true;

        programs.eww = {
          enable = true;
          enableZshIntegration = true;
        };

        programs.yt-dlp.enable = true;

        programs.floorp.enable = true;

        programs.ssh.enable = true;

        services.gpg-agent = {
          enable = true;
          pinentry.package = pkgs.pinentry-curses;
        };
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
