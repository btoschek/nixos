{ config, inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.sleek;
    colorScheme = "Coral";
    wayland = config.wayland.windowManager.hyprland.enable;

    enabledExtensions = with spicePkgs.extensions; [
      # fullAppDisplayMod
    ];
  };
}
