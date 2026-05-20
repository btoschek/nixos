{
  den,
  inputs,
  ...
}: {
  den.hosts.x86_64-linux.gemini = {
    description = "Homelab";
    #users.btoschek = {};     # TODO: Check
  };

  den.aspects.gemini = {
    lib,
    config,
    ...
  }: {
    includes = [
      den.provides.hostname

      # Explicitly define things to keep, wipe the rest on each reboot
      den.aspects.impermanence

      den.aspects.services._.traefik
      den.aspects.services._.homepage
      den.aspects.services._.forgejo
      den.aspects.services._.immich
      den.aspects.services._.jellyfin
    ];

    nixos = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [
        ./_disko.nix
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        defaultSopsFile = builtins.toPath "${inputs.secrets}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";
        age.keyFile = "/persist/keys.txt";
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      nix = {
        settings.experimental-features = ["nix-command" "flakes"];
      };

      # ============================================================
      #  General system settings
      # ============================================================

      boot = {
        # Roll back to empty root filesystem on each boot    old: postDeviceCommands
        # https://discourse.nixos.org/t/zfs-rollbacks-suddenly-stopped-working/55333/3
        #initrd.postResumeCommands = lib.mkAfter ''
        #  zfs rollback -r rpool/local/root@blank
        #'';

        # Use the systemd-boot EFI bootloader
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

      # Networking
      networking = {
        hostId = builtins.substring 0 8 (
          builtins.hashString "sha256" config.networking.hostName
        );
        networkmanager.enable = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            80 # HTTP
            443 # HTTPS
          ];
        };
      };

      # Localization
      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
        keyMap = "de";
      };

      # ============================================================
      #  Users & Access control
      # ============================================================

      # Enable the OpenSSH daemon
      services.openssh = {
        enable = true;
        # ports = [ 5432 ];
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = ["btoschek"];
        };
      };

      # TODO: Proper user management
      # users.groups.media = {};

      # Create a user account
      users.users.btoschek = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOb2UpaouHhHl7+DOclqcvaiWcvuHbpLpOqQ5d+7Z1GZ btoschek"
        ];
      };

      # TODO: Delete, just for testing
      security.sudo.extraRules = [
        {
          users = ["btoschek"];
          commands = [
            {
              command = "ALL";
              options = ["SETENV" "NOPASSWD"];
            }
          ];
        }
      ];

      # ============================================================
      #  Packages
      # ============================================================

      environment.systemPackages = with pkgs; [
        neovim
        git
      ];

      # ============================================================
      #  File backup
      # ============================================================

      # create suid binarys for shutting down all services and restarting
      # after before running restic as non-root
      # users.users.restic = {
      #   isNormalUser = true;
      # };

      # # Run restic without root access
      # security.wrappers.restic = {
      #   source = "${pkgs.restic.out}/bin/restic";
      #   owner = "restic";
      #   group = "users";
      #   permissions = "u=rwx,g=,o=";
      #   capabilities = "cap_dac_read_search=+ep";
      # };

      # KEEP THIS AS IS. THIS DOESN'T AFFECT ANYTHING BUT MAY BREAK EVERYTHING
      system.stateVersion = "24.05";
    };
  };
}
