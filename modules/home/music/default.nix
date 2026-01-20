{ config, pkgs, ... }:

{

  imports = [
    ./mpd.nix
  ];

  home.packages = with pkgs; [
    playerctl

    # Metadata
    picard

    # Post processing
    audacity
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["high-quality"];
    };
  };
}
