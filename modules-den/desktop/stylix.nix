{
  inputs,
  den,
  ...
}: {
  den.aspects.base.homeManager = {pkgs, ...}: {
    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

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

      # TODO: Only set when nixvim enabled
      targets = {
        # Don't style nixvim as it already includes colorscheme
        nixvim.enable = false;
      };
    };
  };
}
