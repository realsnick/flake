# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "fbcon"]; # ""
  boot.extraModulePackages = [];

  # boot.tmp.useTmpfs = true;

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/ROOT";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-label/BOOT";
  #   fsType = "vfat";
  # };

  # fileSystems."/home" = {
  #   device = "/dev/disk/by-label/HOME";
  #   fsType = "ext4";
  # };

  # fileSystems."/Data" = {
  #   device = "/dev/disk/by-label/DATA";
  #   fsType = "ext4";
  # };

  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-label/NIX";
  #   fsType = "ext4";
  # };

  # swapDevices = [
  #   {device = "/dev/disk/by-label/SWAP";}
  # ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp118s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
