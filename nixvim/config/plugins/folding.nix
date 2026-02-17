{config, ...}: {
  plugins.origami = {
    enable = true;

    settings = {
      useLspFoldsWithTreesitterFallback = {
        enabled = true;
        foldmethodIfNeitherIsAvailable = "indent";
      };
      pauseFoldsOnSearch = true;
      foldtext = {
        enabled = true;
        padding = 3;
        lineCount = {
          template = "󰘖 %d";
          hlgroup = "Comment";
        };
        diagnosticsCount = true;
        gitsignsCount = config.plugins.gitsigns.enable;
        disableOnFt = [
          "snacks_picker_input"
        ];
      };
      autoFold = {
        enabled = true;
        kinds = [
          "comment"
          "imports"
        ];
      };
    };
  };
}
