{ config, ... }:

# Taken from: https://www.reddit.com/r/NixOS/comments/1hdsfz0
{
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
      MinConnectionInterval = "7";
      MaxConnectionInterval = "9";
      ConnectionLatency = "0";
    };
  };

  # NOTE: Package currently not building because of missing kernel functions
  # Driver for Xbox One wireless controllers
  # hardware.xpadneo.enable = false;

  # NOTE: Set by `hardware.xpadneo.enable = true`
  # boot = {
  #   extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
  #   extraModprobeConfig = ''
  #     options bluetooth disable_ertm=Y
  #   '';
  # };
}
