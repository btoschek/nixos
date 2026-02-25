{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    inputs.disko.nixosModules.disko
    ../../modules/services
  ];

  # ============================================================
  #  Custom module settings
  # ============================================================

  serviceSettings = {
    domain = "home.lab";
    nasIp = "192.168.20.100";

    traefik.enable = true;
    # immich.enable = true;
    jellyfin.enable = true;
    homepage.enable = true;
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
    initrd.postResumeCommands = lib.mkAfter ''
      zfs rollback -r rpool/local/root@blank
    '';

    # Use the systemd-boot EFI bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  networking = {
    hostName = "gemini";
    hostId = builtins.substring 0 8 (
      builtins.hashString "sha256" config.networking.hostName
    );
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        8080 # Traefik dashboard (HTTP)
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
  #  Impermanence
  # ============================================================

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    allowTrash = false;

    directories = [
      "/var/log"
      # See: https://github.com/nix-community/impermanence/issues/178
      "/var/lib/nixos"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
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

  # KEEP THIS AS IS. THIS DOESN'T AFFECT ANYTHING BUT MAY BREAK EVERYTHING
  system.stateVersion = "24.05";
}
