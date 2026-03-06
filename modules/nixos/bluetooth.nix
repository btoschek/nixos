{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.bluetooth;
in {
  options = {
    systemSettings.bluetooth = {
      enable = lib.mkEnableOption "Enable bluetooth";
    };
  };

  # Taken from: https://www.reddit.com/r/NixOS/comments/1hdsfz0
  config = lib.mkIf cfg.enable {
    # Enable Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings.General = {
        # Show battery
        Experimental = true;

        # Support for pairing controllers
        Class = "0x000100";
        FastConnectable = true;
        Privacy = "device";
        JustWorksRepairing = "always";
      };

      settings.LE = {
        MinConnectionInterval = 7;
        MaxConnectionInterval = 9;
        ConnectionLatency = 0;
      };
    };

    # Driver for Xbox One wireless controllers
    hardware.xpadneo.enable = false;
  };
}
