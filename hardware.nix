# Re-generate w/ ‘nixos-generate-config --show-hardware-config’

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    "root".device = "/dev/disk/by-uuid/14153b07-d8ae-47e3-b230-2111db354065";
    "swap".device = "/dev/disk/by-uuid/abde8d3d-a053-4197-819b-dfb428fb02fe";
  };

  fileSystems."/" = { # decrypted "root"
    device = "/dev/disk/by-uuid/a7cc4c99-9102-491f-a7ff-9d5d71e127c1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0CF6-7559";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ # decrypted "swap"
    { device = "/dev/disk/by-uuid/c33f8a38-6c46-4732-9185-aba5bf6b3c9e"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
