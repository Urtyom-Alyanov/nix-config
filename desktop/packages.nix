{ inputs, pkgs, libs, ... }: {
  programs = {
    nix-ld.enable = true;
    steam.enable = true;
    firefox.enable = true;
    fish.enable = true;
    prism-launcher.enable = true;
  };

  environment.systemPackages = with pkgs; [
    micro
    wget
    wl-clipboard
    wayland-utils

    dotnet-aspnetcore_10
    dotnet-sdk_10

    # inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
    # python313Packages.kde-material-you-colors
    # darkly
    # papirus-icon-theme
    # kdePackages.sierra-breeze-enhanced
    # plasma-panel-colorizer
    # kde-rounded-corners
  ];
}