{ config, lib, ... }:

let
  cfg = config.userSettings.dunst;
in
{
  options = {
    userSettings.dunst = {
      enable = lib.mkEnableOption "Enable dunst";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 200;
          offset = "(30,50)";
          origin = "top-right";
          transparency = 10;
          frame_color = "#${config.lib.stylix.colors.base03}";
        };

        urgency_normal = {
#           background = "#${config.lib.stylix.colors.base00}";
#           foreground = "#${config.lib.stylix.colors.base05}";
          timeout = 10;
        };
      };
    };
  };
}
