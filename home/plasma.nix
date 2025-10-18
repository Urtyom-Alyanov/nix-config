{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
    python313Packages.kde-material-you-colors
    darkly
    papirus-icon-theme
    kdePackages.sierra-breeze-enhanced
    plasma-panel-colorizer
    kde-rounded-corners
  ];

  programs.plasma = {
    enable = true;
    workspace = {
      iconTheme = "Papirus";
      colorTheme = "MaterialYouDark";
      wallpaperFillMode = "stretch";
      windowDecorations = {
        theme = "Sierra Breeze Enhanced";
        library = "org.kde.sierrabreezeenhanced";
      };
    };
  };
}