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

    homeModules.${username} = {pkgs, ...}: {
      imports = with self.homeModules; [
        gui
        base
        development
        gaming
        music
      ];

      home.packages = with pkgs; [
        yq-go
        p7zip
      ];

      programs.yt-dlp.enable = true;
      programs.floorp.enable = true;

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # TODO: Check if correct here
      home.stateVersion = "25.05";
    };
  };
}
