{
  inputs,
  den,
  ...
}: {
  # Support for angle bracket syntax
  _module.args.__findFile = den.lib.__findFile;

  # NOTE: Used for introspection and debugging of aspect options
  flake.den = den;

  imports = [
    inputs.den.flakeModule
  ];

  den.default = {
    homeManager.home.stateVersion = "25.05";
  };
}
