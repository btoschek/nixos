{
  inputs,
  den,
  ...
}: {
  # Support for angle bracket syntax
  _module.args.__findFile = den.lib.__findFile;

  # NOTE: Used for introspection and debugging of aspect options
  # flake.den = den;

  imports = [
    inputs.den.flakeModule
  ];

  den.default = {
    homeManager.home.stateVersion = "25.05";

    nixos = {config, ...}: {
      # Localization
      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
        keyMap = "de";
        useXkbConfig = false;
      };

      # NOTE: Primarily needed for ZFS pool generation
      networking.hostId = builtins.substring 0 8 (
        builtins.hashString "sha256" config.networking.hostName
      );
    };
  };
}
