{den, ...}: {
  den.quirks.remote-filesystems = {
    description = "Declarations of remote filesystem mounts";
  };

  den.policies.nfs-mounts = {host, ...}: let
    inherit (den.lib.policy) pipe;
  in [
    pipe.from
    "remote-filesystems"
    [
      (pipe.collect ({host, ...}: true))
      (pipe.filter (m: m.type == "nfs"))
    ]
  ];

  den.default.nixos = {remote-filesystems, ...}: let
    nasIp = "192.168.20.100";
  in {
    fileSystems = builtins.listToAttrs (builtins.map (m: {
        name = m.local;
        value = {
          device = "${nasIp}:${m.remote}";
          fsType = m.type;
        };
      })
      remote-filesystems);
  };
}
