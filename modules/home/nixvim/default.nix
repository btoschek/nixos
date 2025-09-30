{ inputs, pkgs, ... }:

{

  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
      };
    };

    clipboard.register = "unnamedplus";

    globals.mapleader = " ";
    opts = import ./options.nix;

    keymaps = import ./keymaps.nix;
  };

}
