{ config, lib, pkgs, ... }: {
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8d30fb61-104b-4779-98dd-ce6732877fd2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9BF2-46DC";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/402adf62-d8d9-4e95-840d-d0da49dd46b1";
      fsType = "btrfs";
    };

  swapDevices = [ ];
}