{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos.khora = {
    config,
    lib,
    pkgs,
    modulesPath,
    nixpkgs,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = ["amdgpu"];
    boot.kernelModules = ["kvm-amd" "sg"];
    boot.kernelPackages = pkgs.linuxPackages_latest;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/6829f290-35a7-4e5f-b2c4-fa511a746d9b";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/D099-934F";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/479c6d1f-0b7d-49af-9e00-1f9dbf08485f";}
    ];

    fileSystems."/home/btoschek" = {
      device = "/dev/disk/by-uuid/4ec95c7a-5c97-4c57-899f-07b361d9f912";
      fsType = "ext4";
    };

    fileSystems."/home/btoschek/Games" = {
      device = "/dev/disk/by-uuid/56e2c82e-b05b-45de-8133-a86dd853ca0c";
      fsType = "ext4";
    };

    fileSystems."/home/btoschek/Videos" = {
      device = "/dev/disk/by-uuid/71d0d13a-d4a0-4c81-8ec9-d6d5947daea1";
      fsType = "ext4";
    };

    networking.useDHCP = lib.mkDefault true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
