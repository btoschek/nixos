{
  inputs,
  lib,
  ...
}: {
  flake.homeModules.music = {pkgs, ...}: {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "spotify"
      ];

    imports = [
      inputs.spicetify-nix.homeManagerModules.spicetify
    ];

    programs.spicetify = {
      enable = true;
      wayland = true;

      # enabledExtensions = with spicePkgs.extensions; [
      #   # fullAppDisplayMod
      # ];
    };
  };
}
