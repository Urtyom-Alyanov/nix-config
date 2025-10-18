{ config, pkgs, lib, ... }:

{
  imports = (lib.allExceptThisDefault ./.);

  home.username = "artemos";
  home.homeDirectory = "/home/artemos";
  home.packages = with pkgs; [
    # Общие CLI-утилиты
    git
    micro
    zsh
    firefox
    direnv

    # Шрифты и темы (доступны везде)
    noto-fonts
    nerd-fonts.fira-code
    liberation_ttf
    papirus-icon-theme
  ];

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Russian language pack
          ms-ceintl.vscode-language-pack-ru
          # Theme
          enkia.tokyo-night
          # Icon theme
          catppuccin.catppuccin-vsc-icons
          # Git integration
          eamodio.gitlens

          # AI tools
          github.copilot
          github.copilot-chat

          # Python tools
          ms-python.python
          ms-python.vscode-pylance
          ms-python.pylint
          ms-python.debugpy

          # C# / .NET tools
          ms-dotnettools.csdevkit
          ms-dotnettools.vscodeintellicode-csharp
          ms-dotnettools.vscode-dotnet-runtime
          ms-dotnettools.csharp
        ];
        userSettings = {
          "security.workspace.trust.untrustedFiles" = "open";
          "editor.cursorBlinking" = "expand";
          "editor.tabSize" = 2;
          "files.autoSave" = "onFocusChange";
          "editor.formatOnSave" = true;
          "workbench.iconTheme" = "catppuccin-mocha";
          "workbench.colorTheme" = "Tokyo Night Dark";
          "workbench.sideBar.location" = "right";
        };
      };
    };
  };
  programs.git.enable = true;
  programs.zsh.enable = true;

  # Общие настройки GTK (влияют и на KDE, и на Hyprland)
  gtk = {
    enable = true;
    theme = {
      name = "Breeze";
      package = pkgs.breeze-gtk;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirs = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };

    # autostart = {
    #   enable = true;
    # };
  };
}