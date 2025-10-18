{ config, inputs, pkgs, ... }:

{

  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
    ../../modules/home/programs/media.nix
    ../../modules/home/desktop
    ../../modules/home/terminal
  ];

  userSettings = {
    hyprland.enable = true;
    kitty.enable = true;
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "btoschek";
  home.homeDirectory = "/home/btoschek";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.nerd-fonts.hack
    inputs.nixvim.packages.x86_64-linux.default

    # Rust development
    pkgs.rust-analyzer

    pkgs.ruff
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

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Environment variables available to shells managed by home-manager
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
