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
      MinConnectionInterval = 7;
      MaxConnectionInterval = 9;
      ConnectionLatency = 0;
    };
  };

  # Driver for Xbox One wireless controllers
  hardware.xpadneo.enable = false;
}
