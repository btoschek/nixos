{lib, ...}: {
  imports = [
    ./impermanence.nix
    ./bluetooth.nix
  ];

  options.systemSettings = {
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain of the device";
    };

    nasIp = lib.mkOption {
      type = lib.types.str;
      description = "IP adress of the local NAS";
    };
  };
}
