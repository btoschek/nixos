{
  den,
  lib,
  inputs,
  ...
}: {
  den.schema.host = {
    options = {
      impermanence.persistence-dir = lib.mkOption {
        type = lib.types.str;
        default = "/persist";
        description = "Directory all persistent data will be saved to";
      };
    };
  };

  den.quirks.persist-directories = {
    description = "Declarations of directories to keep when using impermanence";
  };

  den.aspects.impermanence = {
    nixos = {
      host,
      lib,
      persist-directories,
      ...
    }: {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      environment.persistence."${host.impermanence.persistence-dir}" = {
        enable = true;
        hideMounts = true;
        allowTrash = false;

        directories =
          [
            "/var/log"
            # See: https://github.com/nix-community/impermanence/issues/178
            "/var/lib/nixos"
          ]
          ++ persist-directories;

        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
        ];
      };
    };
  };
}
