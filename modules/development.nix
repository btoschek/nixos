{den, ...}: {
  den.aspects.development.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      devenv
      gh # Used by nixvim. TODO: Somehow move to config
      hub
    ];

    # TODO: Include editor here as well

    programs.direnv = {
      enable = true;
      enableZshIntegration = true; # TODO
    };

    programs.gpg.enable = true;
  };
}
