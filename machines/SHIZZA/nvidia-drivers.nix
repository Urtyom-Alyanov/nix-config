{ config, lib, pkgs }:
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;

    open = true;
    gsp.enable = true;

    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}