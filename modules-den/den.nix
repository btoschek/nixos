{
  inputs,
  den,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.default.homeManager.home.stateVersion = "25.05";

  # Declare khora system with associated users
  den.hosts.x86_64-linux.khora = {
    users = {
      btoschek = {};
    };
  };
}
