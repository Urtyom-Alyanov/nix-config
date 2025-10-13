{ config, lib, pkgs, ... }:
{
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    font = "cyr-sun16";
    useXkbConfig = true; # use xkb.options in tty.
  };
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:caps_toggle";
}