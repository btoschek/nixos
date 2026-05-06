{
  inputs,
  den,
  ...
}: {
  # Support for angle bracket syntax
  _module.args.__findFile = den.lib.__findFile;

  imports = [
    inputs.den.flakeModule
  ];

  den.default = {
    homeManager.home.stateVersion = "25.05";
  };

  # Homelab
  den.hosts.x86_64-linux.gemini = {
    users.btoschek = {};
    # NOTE: Uses sops & impermanence -> TODO
  };
}
