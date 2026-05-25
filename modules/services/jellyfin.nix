{den, ...}: {
  den.aspects.services.provides.jellyfin = let
    dataDir = "/var/lib/jellyfin";
  in {
    nixos = {
      services.jellyfin = {
        enable = true;
        inherit dataDir;
      };
    };

    remote-filesystems = {
      remote = "/mnt/storage0/media";
      local = "/mnt/jellyfin/media";
      type = "nfs";
    };

    persist.directories = [
      dataDir
    ];

    routes = {
      service = "jellyfin";
      subdomain = "jellyfin";
      port = 8096;
    };
  };
}
