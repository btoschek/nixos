{
  inputs,
  den,
  ...
}: {
  den.aspects.base.homeManager = {pkgs, ...}: {
    imports = [
      inputs.nixvim.homeModules.nixvim
    ];

    home.packages = with pkgs; [
      alejandra
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.nixvim = {
      enable = true;

      imports = [
        ./_keymaps.nix
        ./_options.nix
        ./_plugins
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
