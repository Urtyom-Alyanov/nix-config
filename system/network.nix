{ config, lib, pkgs, ... }:
{
  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services.zapret-discord-youtube = {
  	enable = true;
  	config = "general(ALT)";
  };
  
  services.dnscrypt-proxy = {
	  enable = true;
	  settings = {
	    ipv6_servers = true;
	    require_dnssec = true;
	    # Add this to test if dnscrypt-proxy is actually used to resolve DNS requests
	    # query_log.file = "/var/log/dnscrypt-proxy/query.log";
	    sources.public-resolvers = {
	      urls = [
	        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
	        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
	      ];
	      cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
	      minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = [ "comss.one" ];
    };
  };
}