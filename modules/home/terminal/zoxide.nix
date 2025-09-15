{ config, ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
  };

  programs.fzf = {
    enable = config.programs.zoxide.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };
}
