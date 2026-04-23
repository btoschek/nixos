{
  flake.homeModules.music = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Metadata
      picard

      # Post processing
      audacity
    ];
  };
}
