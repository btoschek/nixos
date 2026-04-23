{den, ...}: {
  den.aspects.music.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      playerctl
    ];

    # TODO: Move to media
    programs.mpv = {
      enable = true;
      defaultProfiles = ["high-quality"];
    };
  };
}
