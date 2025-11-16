{ config, inputs, pkgs, ... }:

{

  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.stylix.homeModules.stylix
    ../../modules/home/programs/media.nix
    ../../modules/home/desktop
    ../../modules/home/terminal
    ../../modules/home/development
    ../../modules/home/stylix.nix
  ];

  userSettings = {
    hyprland.enable = true;
    kitty.enable = true;
    gaming.enable = true;
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

  # Environment variables available to shells managed by home-manager
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
