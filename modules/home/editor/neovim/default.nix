{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.userSettings.neovim;
in {
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  options = {
    userSettings.neovim = {
      enable = lib.mkEnableOption "Enable neovim (nixvim)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.nixvim = {
      enable = true;

      imports = [
        ./keymaps.nix
        ./options.nix
        ./plugins
      ];

      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night";
        };
      };
    };
  };
}
