{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    devenv
  ];

  # Automatically enter development environments set up by devenv
  programs.direnv = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
  };

  programs.gpg.enable = true;
}
