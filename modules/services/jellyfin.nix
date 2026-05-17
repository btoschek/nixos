{den, ...}: {
  den.aspects.services.provides.jellyfin = {
    services.jellyfin = {
      enable = true;
    };

    remote-filesystems = {
      remote = "/mnt/storage0/media";
      local = "/mnt/jellyfin/media";
      type = "nfs";
    };

    persist.directories = {config, ...}: [
      config.services.jellyfin.dataDir
    ];

    routes = {
      service = "jellyfin";
      subdomain = "jellyfin";
      port = 8096;
    };
  };
}
