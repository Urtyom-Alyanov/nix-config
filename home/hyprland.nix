{ pkgs, lib, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = {
      # Applications
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      "$browser" = "${pkgs.firefox}/bin/firefox";
      "$launcher" = "${pkgs.rofi}/bin/rofi";
      "$editor" = "${pkgs.vscode}/bin/code-insiders";
      "$filemanager" = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      "$bar" = "${pkgs.waybar}/bin/waybar";
      "$screenshot" = "${pkgs.hyprshot}/bin/hyprshot";
      "$notificationDaemon" = "${pkgs.mako}/bin/mako";
      "$keyManager" = "${pkgs.kdePackages.kwallet}/bin/kwalletd6 & ${pkgs.kdePackages.kwallet-pam}/usr/lib/pam_kwallet_init";
      "$wpctl" = "${pkgs.wireplumber}/bin/wpctl";
      "$brightnessctl" = "${pkgs.brightnessctl}/bin/brightnessctl";
      "$playerctl" = "${pkgs.playerctl}/bin/playerctl";
      
      experimental = {
        xx_color_management_v4 = true;
      };
      monitorv2 = [
        {
          output = "DP-1";
          mode = "2560x1440@320";
          position = "auto";
          scale = 1;
          supports_wide_color = 1;
          supports_hdr = 1;
          bitdepth = 10;
          vrr = 1;
          cm = "srgb";

          # Enable HDR color management settings if fully supported
          #cm = hdredid;
          #min_luminance = 0.005;
          #max_avg_luminance = 600;
          #max_luminance = 750;

          #sdr_min_luminance = 0.005;
          #sdr_max_luminance = 750;
        }
        {
          output = "eDP-1";
          mode = "1920x1200@60";
          position = "auto";
          scale = 1;
          supports_wide_color = 1;
          supports_hdr = 1;
          bitdepth = 10;
          vrr = 1;
          cm = "srgb";

          # Enable HDR color management settings if fully supported
          #cm = hdredid;
          #min_luminance = 0.005;
          #max_avg_luminance = 600;
          #max_luminance = 750;

          #sdr_min_luminance = 0.005;
          #sdr_max_luminance = 750;

        }
      ];

      exec-once = [
        "$bar"        
        "$notificationDaemon"
        "$keyManager"
      ];

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, W, exec, $browser"
        "$mainMod, E, exec, $filemanager"
        "$mainMod, R, exec, $launcher -show drun"
        "$mainMod, C, exec, $editor"

        "$mainMod, Q, killactive,"
        "$mainMod CONTROL, Q, exit,"
        "$mainMod, L, exec, loginctl lock-session"

        "ALT, PRINT, exec, $screenshot -m window --freeze"
        ", PRINT, exec, $screenshot -m screen --freeze"
        "SHIFT, PRINT, exec, $screenshot -m region --freeze"

        "$mainMod SHIFT, S, exec, $screenshot -m region --freeze"

        "$mainMod SHIFT, F, togglefloating,"
        "$mainMod CONTROL, F, pseudo,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, A, togglesplit,"

        "$mainMod, left, movefocus, l"
        "$mainMod, down, movefocus, d"
        "$mainMod, up, movefocus, u"
        "$mainMod, right, movefocus, r"

        "$mainMod CONTROL, right, movewindow, r"
        "$mainMod CONTROL, left, movewindow, l"
        "$mainMod CONTROL, down, movewindow, d"
        "$mainMod CONTROL, up, movewindow, u"

        "$mainMod, TAB, togglespecialworkspace, magic"
        "$mainMod SHIFT, TAB, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_down, workspace, e-1"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mainMod, ${toString ws}, workspace, ${toString ws}"
              "$mainMod SHIFT, ${toString ws}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

      binde = [
        "$mainMod SHIFT, right, resizeactive, 20 0"
        "$mainMod SHIFT, left, resizeactive, -20 0"
        "$mainMod SHIFT, down, resizeactive, 0 20"
        "$mainMod SHIFT, up, resizeactive, 0 -20"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod ALT, Control_L, movewindow"
        "$mainMod , Shift_L, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, $wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, $wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, $brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, $brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, $playerctl next"
        ", XF86AudioPrev, exec, $playerctl previous"
        ", XF86AudioPlay, exec, $playerctl play-pause"
        ", XF86AudioPause, exec, $playerctl play-pause"
        ", XF86AudioStop, exec, $playerctl stop"
      ];

      windowrule = [
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      gesture = [
        "3, up, dispatcher, exec, $launcher -show drun"
        "3, down, dispatcher, exec, $terminal"
        "3, horizontal, workspace"
        "2, pinchout, dispatcher, exec, $screenshot -m region --freeze"
      ];

      device = [
        {
          name = "beken-usb-gaming-mouse-2";
          sensitivity = -0.2;
        }
      ];

      inputs = {
        kb_layout = "us,ru";
        kb_options = "grp:caps_toggle";
      
        follow_mouse = 2;

        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      worspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      animations = {
        enabled = true;

        bezier = [
          "overshoot, 0.05, 0.9, 0.1, 1.1"
          "overshootMini, 0.05, 1, 0.1, 1.05"
        ];

        animation = [
          "global, 1, 5, overshoot"
          "windows, 1, 5, overshoot, popin 0%"
          "workspaces, 1, 2.5, overshoot, popin 0%"
          "specialWorkspace, 1, 5, overshootMini, slidevert"
          "layers, 1, 3, overshoot, popin 0%"
        ];

        blurls = [
          waybar
          rofi
          mako
        ];
      };

      decoration = {
        rounding = 12;
        rounding_power = 4;

        active_opacity = 0.95;
        inactive_opacity = 0.85;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;

          vibrancy = 0.1696;
          popups = true;
          new_optimizations = true;
          special = true;
          ignore_opacity = true;
        };
      };

      layerrule = [
        "blur,waybar"
        "blur,rofi"
        "blur,mako"
        "noanim,selection"
      ];

      general = {
        border_size = 2;

        gaps_in = 5;
        gaps_out = 20;

        col = {
          active_border = "rgba(7aa2f7ff)";
          inactive_border = "rgba(3b4261ff)";
        };

        resize_on_border = true;

        allow_tearing = false;

        layout = "dwindle";
      };

      plugin = {
        dynamic-cursors = {
          enabled = true;
          mode = "stretch";
          threshold = 1;

          stretch = {
            limit = 3000;
            function = "quadratic";
            window = 100;
          };

          shake = {
            enabled = true;
            nearest = false;
            threshold = 6.0;
            base = 4.0;
            speed = 4.0;
            influence = 0.0;
            limit = 0.0;
            timeout = 2000;
            effects = true;
            ipc = false;
          };

          hyprcursor = {
            nearest = false;
            enabled = true;
            resolution = -1;
            fallback = "left_ptr";
          };
        };
      };
    };
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    ];
  };

  programs = {
    waybar = {
      enable = true;
      settings = {
        layer = "top";
        position = "top";
        spacing = 4;
        height = 42;
        modules-left = ["custom/launcher" "hyprland/workspaces" "group/system-monitor"];
        modules-center = ["hyprland/window"];
        modules-right = ["tray" "hyprland/language" "group/pluggables" "clock"];

        # Left modules
        "custom/launcher" = {
          on-click = "${pkgs.rofi}/bin/rofi -show drun";
          interval = 0;
          format = "";
        };

        "hyprland/workspaces" ={
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{name}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
        };

        # System monitor modules
        "group/system-monitor" = {
          modules = [
            "cpu"
            "memory"
            "temperature"
            "disk"
          ];
          orientation = "horizontal";
        };
        cpu = {
          format = "  {usage}%";
          tooltip = true;
        };
        memory = {
          format = "  {}%";
          tooltip = true;
        };
        temperature = {
          interval = 10;
          hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input";
          critical-threshold = 100;
          format-critical = " {temperatureC}";
          format = " {temperatureC}°C";
        };
        disk = {
          format = "  {free}";
          path = "/home";
          threshold-warning = 80;
          threshold-critical = 90;
          tooltip = true;
        };

        # Center module
        "hyprland/window" = {
          max-length = 30;
          icon = true;
          tooltip = true;
        };

        # Right modules
        "tray" = {
          icon-size = 16;
          max-size = 12;
        };

        "hyprland/language" = {
          format = "󰛍 {}";
          format-en = "EN";
          format-ru = "RU";
          on-click = "hyprctl switchxkblayout all next";
        };

        # Pluggable modules
        "group/pluggables" = {
          modules = [
            "wireplumber"
            "network"
            "bluetooth"
            "battery"
          ];
          orientation = "horizontal";
        };
        wireplumber = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%  {format_source}";
          format-bluetooth-muted = "󰗿 {icon} {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "󰋋";
            hands-free = "";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            car = "󰄋";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
        };
        network = {
          format-wifi = "󰖩  {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          on-click = "kitty nmtui";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-full = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        clock = {
          format = "{:%H:%M | %e %B} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
      };
      style = ''
        * {
          /* `otf-font-awesome` and SpaceMono Nerd Font are required to be installed for icons */
          font-family: "FiraCode Nerd Font", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
          font-size: 15px;
          transition: background-color .3s ease-out;
        }

        window#waybar {
          background: rgba(26, 27, 38, 0.85);
          color: #c0caf5;
          font-family:
            SpaceMono Nerd Font,
            feather;
          transition: background-color .5s;
        }

        #tray,
        .modules-center,
        #clock,
        #system-monitor,
        #custom-launcher,
        #pluggables,
        #language,
        #workspaces {
          background: rgba(36, 40, 59, 0.65);
          margin: 5px 2.5px;
          border-radius: 17px;
          border-color: #24283b;
          border-width: 2px;
          border-style: solid;
        }

        .modules-left {
          padding: 0;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #scratchpad,
        #window,
        #power-profiles-daemon,
        #language,
        #mpd {
          padding: 0 10px;
          border-radius: 15px;
        }

        #clock:hover,
        #battery:hover,
        #network:hover,
        #wireplumber:hover,
        #mode:hover,
        #idle_inhibitor:hover,
        #scratchpad:hover,
        #language:hover {
          background: rgba(122, 162, 247, 0.65);
        }


        #workspaces button, #tray>* {
          background: transparent;
          font-family:
            SpaceMono Nerd Font,
            feather;
          font-weight: 900;
          font-size: 13pt;
          color: rgba(122, 162, 247, 0.65);
          border: none;
          border-radius: 15px;
        }

        #workspaces button.active, #tray>.needs-attention {
          background: rgba(122, 162, 247, 0.65);
          color: #24283b;
        }

        #workspaces button:hover, #tray>*:hover {
          background: #24283b;
          color: #7aa2f7;
          box-shadow: none;
        }

        #custom-launcher {
          margin-left: 5px;
          padding: 0 10px;
          padding-right: 14px;
          font-size: 20px;
          transition: color .5s;
        }

        #custom-launcher:hover {
          color: #1793d1;
        }

        window#waybar.empty #window, window#waybar.empty .modules-center {
          padding: 0;
          border-width: 0;
        }

      '';
    };

    rofi = {
      enable = true;
      font = "FiraCode Nerd Font 12";
      theme = ''
        configuration {
            show-icons:      true;
            display-drun:    "";
            disable-history: false;
            display-rows: 10;
            display-columns: 3;
        }

        * {
            font: "FiraCode Nerd Font 12";
            foreground: #c0caf5;
            standard-background: rgba(26, 27, 38, 0.75);
            active-background: rgba(122, 162, 247, 0.65);
            urgent-background: rgba(36, 40, 59, 0.65);
            urgent-foreground: #c0caf5;
            selected-background: @active-background;
            selected-urgent-background: @urgent-background;
            selected-active-background: @active-background;
            separatorcolor: @active-background;
            bordercolor: @active-background;
        }

        #window {
            background-color: @standard-background;
            border:           3;
            border-radius:    17;
            border-color:     @bordercolor;
            padding:          7;
        }
        #mainbox {
            border:  0;
            padding: 0;
        }
        #message {
            border:       0px;
            border-color: @separatorcolor;
            padding:      1px;
        }
        #textbox {
            text-color: @foreground;
        }
        #listview {
            fixed-height: 0;
            border:       0px;
            border-color: @bordercolor;
            spacing:      3px ;
            scrollbar:    false;
            padding:      2px 0px 0px ;
        }
        #element {
            border:  0;
            border-radius: 12px;
        }
        #element.normal.normal {
            background-color: rgba(0,0,0,0);
            text-color:       @foreground;
        }
        #element.normal.urgent {
            background-color: @urgent-background;
            text-color:       @urgent-foreground;
        }
        #element.normal.active {
            background-color: @active-background;
            text-color:       @foreground;
        }
        #element.selected.normal {
            background-color: @selected-background;
            text-color:       @foreground;
        }
        #element.selected.urgent {
            background-color: @selected-urgent-background;
            text-color:       @foreground;
        }
        #element.selected.active {
            background-color: @selected-active-background;
            text-color:       @foreground;
        }
        #element.alternate.normal {
            background-color: rgba(0,0,0,0);
            text-color:       @foreground;
        }
        #element.alternate.urgent {
            background-color: @urgent-background;
            text-color:       @foreground;
        }
        #element.alternate.active {
            background-color: @active-background;
            text-color:       @foreground;
        }
        element-icon {
          size: 2.5ch;
        }
        #scrollbar {
            width:        2px ;
            border:       0;
            handle-width: 8px ;
            padding:      0;
        }
        #sidebar {
            border:       2px dash 0px 0px ;
            border-color: @separatorcolor;
        }
        #button.selected {
            background-color: @selected-background;
            text-color:       @foreground;
        }
        #inputbar {
            spacing:    0;
            text-color: @foreground;
            padding:    1px ;
        }
        #case-indicator {
            spacing:    0;
            text-color: @foreground;
        }
        #entry {
            spacing:    0;
            text-color: @foreground;
        }
        #prompt {
            spacing:    0;
            text-color: @foreground;
        }
        #inputbar {
            children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
        }
        #textbox-prompt-colon {
            expand:     false;
            str:        ">";
            margin:     0px 0.3em 0em 0em ;
            text-color: @foreground;
            padding: 2px 15px;
            border-radius: 12px;
            background-color: @active-background;
        }
        element-text, element-icon {
            background-color: rgba(0,0,0,0);
            text-color: inherit;
            padding: 5px;
        }
      '';
    };

    hyprshot.enable = true;

    hyprlock = {
      enable = true;
      settings = {
        "$background" = "rgb(24283b)";
        "$foreground" = "rgb(c0caf5)";
        "$foregroundRaw" = "c0caf5";
        "$accentRaw" = "7aa2f7";
        "$accent" = "rgb(7aa2f7)";
        "$red" = "rgb(f7768e)";
        "$yellow" = "rgb(e0af68)";

        "$font" = "FiraCode Nerd Font";

        general = {
          hide_cursor = true;
        };

        background = [{
          path = "~/.wp";
          blur_passes = 2;
          blur_radius = 15;
          color = "$background";
        }];

        shape = [
          {
            size = "450, 220";
            color = "$background";
            outline_thickness = 4;
            outline_color = "$accent";
            rounding = 25;
            position = "0, 20";
            halign = "center";
            valign = "center";
          }
          {
            size = "110, 60";
            color = "$background";
            outline_thickness = 4;
            outline_color = "$accent";
            rounding = 15;
            position = "-250, -35";
            border_size = 3;
            border_color = "$accent";
            halign = "center";
            valign = "center";
          }
          {
            size = "60, 60";
            color = "$background";
            outline_thickness = 4;
            onclick = "hyprctl switchxkblayout all next";
            outline_color = "$accent";
            rounding = 15;
            position = "230, -35";
            border_size = 3;
            border_color = "$accent";
            halign = "center";
            valign = "center";
          }
        ];
        
        label = [
          {
            text = "$TIME";
            color = "$foreground";
            font_size = 90;
            font_family = "$font";
            position = "30, 0";
            halign = "left";
            valign = "top";
          }
          {
            text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
            color = "$foreground";
            font_size = 25;
            font_family = "$font";
            position = "30, -150";
            halign = "left";
            valign = "top";
          }
          {
            text = $LAYOUT[US,RU];
            font_size = 22;

            position = "230, -35";
            color = "$foreground";
            halign = "center";
            valign = "center";
          }
          {
            text = "cmd[update:1000] echo -e \"$(~/.config/hypr/battery-stat)\"";
            position = "-250, -35";
            color = "$foreground";
            halign = "center";
            valign = "center";
            font_size = 18;
          }
        ];

        input-field = [
          {
            size = "300, 60";
            outline_thickness = 4;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "$accent";
            inner_color = "$background";
            font_color = "$foreground";
            fade_on_empty = false;
            placeholder_text = "<span foreground=\"##$foregroundRaw\">󰌾  Сессия /home/<span foreground=\"##$accentRaw\">$USER</span></span>";
            hide_input = false;
            check_color = "$accent";
            fail_color = "$red";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            capslock_color = "$yellow";
            position = "0, -35";
            rounding = 15;
            halign = "center";
            valign = "center";

          }
        ];
      };
    };
  };

  services = {
    mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        font = "FiraCode Nerd Font 12";
        format = "%a %s";
        background-color = "#1a1b26bf";
        foreground-color = "#c0caf5ff";
        border-color = "#7aa2f7";
        border-size = 3;
        border-radius = 17;
        margin = 10;
        padding = 10;
        width = 300;
        height = 50;
        position = "top-right";
        max-visible = 3;
        spacing = 10;
        icon-size = 32;
      };
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 150;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 300;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 600;
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
  };
}