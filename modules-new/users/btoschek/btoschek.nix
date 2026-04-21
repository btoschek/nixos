{self, ...}: let
  username = "btoschek";
in {
  flake = {
    nixosModules.${username} = {pkgs, ...}: {
      users.users.${username} = {
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = ["wheel" "scanner" "lp"];
        shell = pkgs.zsh;
      };

      programs.zsh.enable = true;

      home-manager.users.${username} = {
        imports = [
          self.homeModules.${username}
        ];
      };
    };

    homeModules.${username} = {
      imports = with self.homeModules; [
        gui
        base
        development
        gaming
        music
      ];

      # TODO: Check if correct here
      home.stateVersion = "25.05";
    };
  };
}
