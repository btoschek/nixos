{den, ...}: {
  den.aspects.services.provides.paperless = let
    port = 28981;
    dataDir = "/var/lib/paperless";
    mediaDir = "/mnt/vault/Documents";
  in {
    nixos = {
      host,
      config,
      pkgs,
      ...
    }: {
      sops.secrets = {
        "services/paperless-ngx/admin-pass" = {
          mode = "0440";
          owner = config.services.paperless.user;
          group = config.services.paperless.user;
        };
      };

      services.paperless = {
        enable = true;
        package = pkgs.paperless-ngx;

        passwordFile = config.sops.secrets."services/paperless-ngx/admin-pass".path;

        address = "127.0.0.1";
        domain = "paperless.${host.domain}"; # TODO: Make dynamic
        inherit port;

        consumptionDirIsPublic = true;
        settings = {
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
        };
      };
    };

    # TODO: Figure out
    #remote-filesystems = {
    #  remote = "/mnt/storage0/vault";
    #  local = "/mnt/vault";
    #  type = "nfs";
    #};

    persist-directories = [
      dataDir
      # NOTE: mediaDir references a NAS mount, no need to persist it
    ];

    routes = {
      service = "paperless";
      subdomain = "paperless";
      inherit port;
    };
  };
}
