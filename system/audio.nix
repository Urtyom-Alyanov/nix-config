{ config, lib, pkgs }:
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

    # Low latency settings
    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
        };
      };  
    };

    # Bluetooth settings (disable auto profile switching and hfp/hsp profiles)
    wireplumber.extraConfig."51-mitigate-annoying-profile-switch" = {
      "monitor.bluez.properties" = {
      	"bluez5.roles" = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" ];
      };

      "wireplumber.settings" = {
      	"bluetooth.autoswitch-to-headset-profile" = false;
      };
    };

    # Enable noise suppression with rnnoise
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/20-rnnoise.conf" ''
        context.modules = [{
          name = libpipewire-module-filter-chain
          args = {
            node.description = "Noise Canceling source"
            media.name = "Noise Canceling source"
            filter.graph = {
              nodes = [
                {
                  type = ladspa
                  name = rnnoise
                  plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so
                  label = noise_suppressor_mono
                  control = {
                    "VAD Threshold (%)" = 50.0
                    "VAD Grace Period (ms)" = 200
                    "Retroactive VAD Grace (ms)" = 0
                  }
                }
              ]
            }
            capture.props = {
              node.name =  "capture.rnnoise_source"
              node.passive = true
              audio.rate = 48000
            }
            playback.props = {
              node.name =  "rnnoise_source"
              media.class = Audio/Source
              audio.rate = 48000
            }
          }
        }]
      '')
    ];
  };

  # Enable realtime scheduling for PipeWire (for lower latency and noise suppression)
  security.rtkit = {
    enable = true;
  };
}