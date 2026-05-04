{den, ...}: {
  den.aspects._3d-printing.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      orca-slicer
      freecad
    ];
  };
}
