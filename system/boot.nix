{ config, lib, pkgs }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # CPIO configuration for the kernel
  hardware.firmwareCompression = "zstd";
  boot.plymouth = {
    enable = true;
  };

  # Bootloader configuration
  boot.loader.systemd-boot = {
    enable = true;
    # Secure Boot support with sbctl (create keys (is not created), enroll keys with microsoft keys (if setup mode), sign binaries)
  	extraInstallCommands = ''
      if [ "$(${pkgs.sbctl}/bin/sbctl status --json | ${pkgs.jq}/bin/jq -r '.installed')" = "false" ]; then
        ${pkgs.sbctl}/bin/sbctl create-keys
      fi
      if [ "$(${pkgs.sbctl}/bin/sbctl status --json | ${pkgs.jq}/bin/jq -r '.setup_mode')" = "true" ]; then
        ${pkgs.sbctl}/bin/sbctl enroll-keys -m
      fi
      ${pkgs.sbctl}/bin/sbctl verify --json | \
      ${pkgs.jq}/bin/jq -r '.[] | select(.is_signed == 0 and (.file_name | test("Microsoft/Boot") | not)) | .file_name' | \
      while read filename; do
        ${pkgs.sbctl}/bin/sbctl sign "$filename"
      done
  	'';
  	configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
}