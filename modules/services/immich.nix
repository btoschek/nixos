{den, ...}: {
  den.aspects.services.provides.immich = let
    port = 2283;
    mediaLocation = "/var/lib/immich";
  in {
    nixos = {
      services.immich = {
        enable = true;
        inherit port;
        inherit mediaLocation;
      };
    };

    remote-filesystems = {
      remote = "/mnt/storage0/vault";
      local = "/mnt/vault";
      type = "nfs";
    };

    persist.directories = [
      mediaLocation

      # NOTE: This directory is needed as immich uses Postgres under the hood
      # WARN: As this directory is versioned ("/var/lib/postgresql/<version>"),
      #       always do a backup before bumping versions to avoid data loss
      #config.services.postgresql.dataDir
      "/var/lib/postgresql/15"
    ];

    routes = {
      service = "immich";
      subdomain = "immich";
      inherit port;
    };
  };
}
