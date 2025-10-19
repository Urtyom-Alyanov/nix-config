{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
    python313Packages.kde-material-you-colors
    darkly
    papirus-icon-theme
    nur.repos.shadowrz.klassy-qt6
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
        theme = "Klassy";
        library = "org.kde.klassy";
      };
    };

    panels = [
      {
        location = "top";
        height = 32;
        floating = true;
        opacity = "translucent";
        lengthMode = "fit";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemmonitor.cpucore"
          "org.kde.plasma.systemmonitor.cpu"
          "org.kde.plasma.systemmonitor.memory"
          "org.kde.plasma.systemmonitor.diskusage"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.mediacontroller"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      {
        location = "bottom";
        height = 48;
        floating = true;
        opacity = "translucent";
        hiding = "auto";
        lengthMode = "fit";
        widgets = [
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.minimizeall"
        ];
      }
    ];
  };

  home.file."kde-material-you-color/config.json".text = ''
    [CUSTOM]
    monitor = 0
    ncolor = 0

    konsole_opacity = 85
    konsole_opacity_dark = 85

    titlebar_opacity = 85
    titlebar_opacity_dark = 85

    toolbar_opacity = 85
    toolbar_opacity_dark = 85

    scheme_variant = 5

    chroma_multiplier = 1

    tone_multiplier = 1

    manual_fetch = False
  '';
}