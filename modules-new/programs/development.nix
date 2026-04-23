{
  flake.homeModules.development = {pkgs, ...}: {
    home.packages = with pkgs; [
      devenv
      gh # Used by nixvim. TODO: Somehow move to config
      hub
    ];

    programs.direnv = {
      enable = true;
      enableZshIntegration = true; # TODO
    };

    programs.gpg.enable = true;
  };
}
