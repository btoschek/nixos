{
  den,
  lib,
  ...
}: {
  den.schema.host = {
    options = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name associated with the device";
      };
    };
  };

  # Declare routes with simplified generic options
  den.quirks.routes = {
    description = "Route declarations usable by any reverse proxy";
  };

  # Extend routes and auto-generate missing information
  den.policies.extend-routes = {host, ...}: let
    inherit (den.lib.policy) pipe;
  in [
    (pipe.from "routes" [
      (pipe.transform (
        r: let
          fqdn = "${r.subdomain}.${host.domain}";
        in
          #assert _ -> r.port != null;
          #assert _ -> r.subdomain != null;
          r
          // lib.optionalAttrs (!(r ? "fqdn")) {inherit fqdn;}
          // lib.optionalAttrs (!(r ? "url")) {url = "https://${fqdn}";}
          // lib.optionalAttrs (!(r ? "internal")) {internal = "http://127.0.0.1:${builtins.toString r.port}";}
      ))
    ])
  ];

  den.default.includes = [
    # Automatically include policy for all hosts
    den.policies.extend-routes

    # Asserts
    {
      nixos = {routes, ...}: let
        occurences = key: lib.groupBy (e: toString e.${key}) routes;
        duplicates = key: lib.filterAttrs (_: group: lib.length group > 1) (occurences key);
      in {
        # Assert following settings are only defined once:
        # - Internal ports
        # - FQDNs
        assertions =
          lib.mapAttrsToList (
            entry: occ: {
              assertion = false;
              message = ''
                quirk(routes): Domain "${entry}" is defined by ${toString (lib.length occ)} services: ${lib.concatMapStringsSep ", " (o: "${o.service}") occ}
              '';
            }
          )
          (duplicates "fqdn")
          ++ lib.mapAttrsToList (
            entry: occ: {
              assertion = false;
              message = ''
                quirk(routes): Port ${entry} is defined by ${toString (lib.length occ)} services: ${lib.concatMapStringsSep ", " (o: "${o.service}") occ}
              '';
            }
          )
          (duplicates "port");
      };
    }
  ];
}
