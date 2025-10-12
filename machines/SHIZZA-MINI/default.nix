{}:
{
  # Lenovo IdeaPad Slim 5 14AHP9
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ] ++ (lib.allExceptThisDefault ./.);

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "sdhci_pci" "usb_storage" "sd_mod" ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.useDHCP = lib.mkDefault true;

  boot.kernelModules = [ "kvm-amd" ];
}