{
  flake.homeModules.music = {pkgs, ...}: {
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
