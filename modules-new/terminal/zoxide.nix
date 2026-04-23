{
  flake.homeModules.base = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true; # TODO
    };

    programs.fzf = {
      enable = true; # TODO
      enableZshIntegration = true; # TODO
    };
  };
}
