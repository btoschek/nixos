{
  inputs,
  lib,
  ...
}: {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.nixosModules.${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = lib.mkDefault system;
          }
        ];
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          inputs.self.homeModules.${name}
          {nixpkgs.config.allowUnfree = true;}
        ];
      };
    };
  };
}
