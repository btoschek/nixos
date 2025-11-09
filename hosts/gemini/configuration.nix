{ config, inputs, lib, pkgs, meta, ... }:

{

  imports = [
    ./disko.nix
    inputs.disko.nixosModules.disko
    ../../services
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  serviceSettings = {
    domain = "home.lab";
    nasIp = "192.168.20.100";

    traefik.enable = true;
    immich.enable = true;
    jellyfin.enable = true;
    homepage.enable = true;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # ============================================================
  #  General system settings
  # ============================================================

  # Use the systemd-boot EFI bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "gemini";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80                     # HTTP
        443                    # HTTPS
        8080                   # Traefik dashboard (HTTP)
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
      AllowUsers = [ "btoschek" ];
    };
  };

  # TODO: Proper user management
  # users.groups.media = {};

  # Create a user account
  users.users.btoschek = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOb2UpaouHhHl7+DOclqcvaiWcvuHbpLpOqQ5d+7Z1GZ btoschek"
    ];
  };

  # TODO: Delete, just for testing
  security.sudo.extraRules = [
    {
      users = [ "btoschek" ];
      commands = [
        {
          command = "ALL";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }
  ];

  # KEEP THIS AS IS. THIS DOESN'T AFFECT ANYTHING BUT MAY BREAK EVERYTHING
  system.stateVersion = "24.05";

}
