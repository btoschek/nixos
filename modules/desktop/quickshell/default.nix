{den, ...}: {
  den.aspects.gui.homeManager = {config, ...}: {
    programs.quickshell = {
      enable = true;
    };

    xdg.configFile."quickshell" = {
      # TODO: Don't use absolute path here
      source = config.lib.file.mkOutOfStoreSymlink "/home/btoschek/nixos/modules/desktop/quickshell/config";
      recursive = true;
    };
  };
}
