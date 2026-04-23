{
  inputs,
  den,
  ...
}: {
  den.aspects.music = {
    includes = [
      (den.provides.unfree [
        "spotify"
      ])
    ];

    homeManager = {pkgs, ...}: {
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
  };
}
