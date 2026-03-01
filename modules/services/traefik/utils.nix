{
  # Register basic routing for services
  generateBasicTraefikEntry = {
    service,
    url,
    internal,
  }: {
    http = {
      routers = {
        "${service}-router" = {
          entryPoints = ["websecure"];
          rule = "Host(`${url}`)";
          inherit service;
          tls.certResolver = "letsencrypt";
        };
      };

      services = {
        "${service}".loadBalancer.servers = [
          {url = internal;}
        ];
      };
    };
  };
}
