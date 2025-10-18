{ config, lib, pkgs, ... }: {
  fileSystems."/" =
    { device = "/dev/disk/by-label/NixOS";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/Home";
      fsType = "ext4";
    };
  fileSystems."/mnt/windows" =
    { device = "/dev/disk/by-label/Windows";
      fsType = "ntfs";
    };

  swapDevices = [ ];
}