{
  # Register basic routing for services
  generateBasicTraefikEntry = { service, url, internal }: {
    http = {
      routers = {
        "${service}-router" = {
          entryPoints = [ "websecure" ];
          rule = "Host(`${url}`)";
          inherit service;
        };
      };

      services = {
        "${service}".loadBalancer.servers = [
          { url = internal; }
        ];
      };
    };
  };
}
