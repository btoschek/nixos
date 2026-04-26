{
  inputs,
  den,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.default.homeManager.home.stateVersion = "25.05";

  # Main PC (Tower)
  den.hosts.x86_64-linux.khora = {
    users.btoschek.classes = ["homeManager"];
  };
  };
}
