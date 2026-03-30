{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    devenv
    gh  # Used by nixvim. TODO: Somehow move to config
    hub
  ];

  # Automatically enter development environments set up by devenv
  programs.direnv = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
  };

  programs.gpg.enable = true;
}
