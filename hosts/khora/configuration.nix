{ inputs, pkgs, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./../../modules/nixos/bluetooth.nix
      ./../../modules/nixos/sddm.nix
    ];

  # Use grub instead of systemd-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  networking.hostName = "khora";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Automatic updating
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  # Automatic cleanup
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    settings.auto-optimise-store = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Consolas";
    keyMap = "de";
    useXkbConfig = false; # use xkb.options in tty.
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {

    # Hint electron apps to using wayland instead of X11
    NIXOS_OZONE_WL = "1";

    # Set xdg variables
    XDG_DESKTOP_DIR = "$HOME/Desktop";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_MUSIC_DIR = "$HOME/Music";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    XDG_PUBLICSHARE_DIR = "$HOME/Public";
    XDG_TEMPLATES_DIR = "$HOME/Templates";
    XDG_VIDEOS_DIR = "$HOME/Videos";
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    keyboard.zsa.enable = true;

    # Support for SANE scanners
    sane.enable = true;
  };

  # Enable sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.btoschek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "scanner" "lp" ]; # Enable ‘sudo’ for the user. + scanner privileges
    packages = with pkgs; [
      tree
      gnupg
    ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "btoschek" = import ./home.nix;
    };
    # Fix use of unfree packages
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget

    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    kitty
    yazi
    swww
    copyq
    grim
    slurp
    wl-clipboard

    wally-cli

    (discord.override { withOpenASAR = true; withVencord = true; })
    bottom

    libnotify
    dunst

    obsidian
    eww
    python3

    rofi-wayland

    thunderbird
    sops
    makemkv

    simple-scan

    gcc
    libreoffice-qt
    pgadmin4-desktopmode

    orca-slicer

    nfs-utils
  ];

  programs.zsh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8000 ]; # Occasional python http.server

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

