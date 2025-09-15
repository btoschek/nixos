{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mangohud
    gamescope
    steam
    prismlauncher
    heroic
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      toggle_hud = "F10";
      gpu_temp = true;
      cpu_temp = true;
      no_display = true;
    };
  };
}
