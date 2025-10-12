{ config, lib, pkgs }:
{
  hardware.bluetooth = {
  	enable = true;
  	settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
  	};
  };

  # Enable mpris-proxy for bluetooth media control
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };  
}