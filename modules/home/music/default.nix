{ config, pkgs, ... }:

{

  imports = [
    ./mpd.nix
    ./spotify.nix
  ];

  home.packages = with pkgs; [
    playerctl

    # Metadata
    picard

    # Post processing
    audacity
  ];

  # TODO: Move to media
  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["high-quality"];
    };
  };
}
