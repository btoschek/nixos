{den, ...}: {
  den.aspects.music.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Metadata
      picard

      # Post processing
      audacity
    ];
  };
}
