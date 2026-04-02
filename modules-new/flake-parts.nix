{inputs, ...}: {
  imports = [
    # Make option "flake.modules" available
    inputs.flake-parts.flakeModules.modules

    # Add management for home-manager options
    # inputs.home-manager.flakeModules.home-manager
  ];

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
}
