{...}: {
  imports = [
    ./traefik
    ./homepage.nix
    ./jellyfin.nix
    ./immich.nix
    ./forgejo.nix
  ];
}
