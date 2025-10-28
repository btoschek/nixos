{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.gaming;
in
{
  options = {
    userSettings.gaming = {
      enable = lib.mkEnableOption "Enable programs related to gaming";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gamescope
      steam
      prismlauncher
      heroic
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
}
