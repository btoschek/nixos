{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mangohud
    gamescope
    steam
    prismlauncher
    heroic
  ];
}
