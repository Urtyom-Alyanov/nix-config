{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      ricoh_sp150suw_driver
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}