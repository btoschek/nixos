{
  den,
  inputs,
  ...
}: {
  # Declare quirk (usable everywhere)
  den.quirks.persist = {
    description = "Declarations of files to keep when using impermanence";
  };

  den.aspects.impermanence = {
    nixos = {
      persist,
      lib,
      ...
    }: {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      environment.persistence."/persist" = {
        enable = true;
        hideMounts = true;
        allowTrash = false;

        directories = [
          "/var/log"
          # See: https://github.com/nix-community/impermanence/issues/178
          "/var/lib/nixos"
        ];
        #++ lib.concatMap (p: p.directories or []) persist;

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
