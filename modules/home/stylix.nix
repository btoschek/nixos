{ pkgs, ... }:

{
  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    fonts = {
#       serif = {
#         package = pkgs.nerd-fonts.hack;
#         name = "Hack Nerd Font Propo";
#       };
#       sansSerif = {
#         package = pkgs.nerd-fonts.hack;
#         name = "Hack Nerd Font Propo";
#       };
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
      # emoji
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    targets = {
      # Don't style neovim as nixvim config already includes colorscheme
      neovim.enable = false;
    };
  };
}
