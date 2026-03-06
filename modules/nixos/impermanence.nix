{lib, ...}: {
  options = {
    systemSettings.impermanence = {
      mountPoint = lib.mkOption {
        type = lib.types.str;
        default = "/persist";
        description = "Mountpoint of directory all persistent data will be saved to";
      };
    };
  };
}
