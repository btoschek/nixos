{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.userSettings.spotify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options = {
    userSettings.spotify = {
      enable = lib.mkEnableOption "Enable spotify";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      wayland = config.wayland.windowManager.hyprland.enable;

      enabledExtensions = with spicePkgs.extensions; [
        # fullAppDisplayMod
      ];
    };
  };
}
