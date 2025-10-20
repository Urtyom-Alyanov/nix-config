{ config, lib, pkgs, ... }: {
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/dfef28af-f920-4ed4-89ea-dd9b4e3bdfab";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9BF2-46DC";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/831824da-26ea-4ff1-ae7c-71e5bd54fdb4";
      fsType = "btrfs";
    };

  swapDevices = [ ];
}