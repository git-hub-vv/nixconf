{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    services.xserver.enable = true;
    services.xserver.displayManager.startx.enable = false;
    services.xserver.desktopManager.xterm.enable = false;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      xwayland
      tokyonight-gtk-theme
      swayimg
      rose-pine-cursor
      pkgs.adwaita-icon-theme
      nemo
      fuzzel
      gpu-screen-recorder
      qt6.qtwayland
      brightnessctl
      ddcutil
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
          user = "greeter";
        };
        init_session = {
          user = "vv";
        };
      };
    };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
    };


  };

  perSystem = { pkgs, lib, self', config, ... }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = let
        # startNoctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.start-noctalia-shell;
        noctaliaExe = lib.getExe pkgs.noctalia-shell;
        terminal = lib.getExe pkgs.ghostty;
      in {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        binds = 
	{
	  "Mod+Shift+Slash".show-hotkey-overlay = null;

          "Mod+Return".spawn-sh = terminal;
	  "Mod+Space".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
          "Mod+Q".close-window = null;
	  "Mod+F".maximize-column = null;
	  "Mod+Shift+F".fullscreen-window = null;
	  "Mod+O".toggle-overview = null;

	  "Mod+Left".focus-column-or-monitor-left = null;
          "Mod+Down".focus-window-down = null;
          "Mod+Up".focus-window-up = null;
          "Mod+Right".focus-column-or-monitor-right = null;
          "Mod+H".focus-column-or-monitor-left = null;
          "Mod+J".focus-window-down = null;
          "Mod+K".focus-window-up = null;
          "Mod+L".focus-column-or-monitor-right = null;

          "Mod+Ctrl+Left".move-column-left-or-to-monitor-left = null;
          "Mod+Ctrl+Down".move-window-down-or-to-workspace-down = null;
          "Mod+Ctrl+Up".move-window-up-or-to-workspace-up = null;
          "Mod+Ctrl+Right".move-column-right-or-to-monitor-right = null;
          "Mod+Ctrl+H".move-column-left-or-to-monitor-left = null;
          "Mod+Ctrl+J".move-window-down-or-to-workspace-down = null;
          "Mod+Ctrl+K".move-window-up-or-to-workspace-up = null;
          "Mod+Ctrl+L".move-column-right-or-to-monitor-right = null;

	  "Mod+BracketLeft".consume-or-expel-window-left = null;
          "Mod+BracketRight".consume-or-expel-window-right = null;

	  "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
	  "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";
	  "Mod+R".switch-preset-column-width = null;
	  "Mod+Shift+R".switch-preset-window-height = null;

	  "Mod+S".screenshot = null;
          "Mod+Shift+S".screenshot-screen = null;
          "Mod+Alt+S".screenshot-window = null;

	  "Mod+WheelScrollDown".focus-column-left = null;
          "Mod+WheelScrollUp".focus-column-right = null;
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = null;
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = null;

	  "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

        };

	outputs = { 
	  "DP-2" = {
	    focus-at-startup = null;
            mode = "2560x1440@180";
            scale = 1;
	    position = _: { props = { x = 0; y = 0; }; };
          };
          "DP-1" = {
            mode = "3840x2160@59.997";
            scale = 1.7;
            #position x=2560 y=20
	    position = _: { props = { x = 2560; y = 20; }; };
          };
          "DP-3" = {
            mode = "2560x1440@74.924";
            transform = "90";
            scale = 1;
            #position x=-1440 y=-560
	    position = _: { props = { x = -1440; y = -560; }; };
          };
	};

        layout = {
	  empty-workspace-above-first = null;
	  background-color = "transparent";
	  gaps = 6;
	  focus-ring = {
	    width = 3;
	    active-color = "#F7ADF0";
	  };
	  preset-column-widths = [
            {proportion = 0.333333;}
            {proportion = 0.5;}
            {proportion = 0.666667;}
          ];
	  preset-window-heights = [
            {proportion = 0.333333;}
            {proportion = 0.5;}
            {proportion = 0.666667;}
          ];
	};

	"screenshot-path" = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

	"window-rules" = [
          {
            "geometry-corner-radius" = 20;
            "clip-to-geometry" = true;
          }
          {
            matches = [ { app-id = "ghostty"; } ];
            opacity = 0.98;
          }
	];

	cursor = {
          "xcursor-theme" = "BreezeX-RosePine-Linux";
          "xcursor-size" = 24;
          "hide-when-typing" = true;
          "hide-after-inactive-ms" = 10000;
        };

	layer-rules =
	[
	  {
            block-out-from = "screen-capture";
            matches = [
              {
                namespace = "^notifications$";
              }
            ];
            opacity = 0.8;
          }
	];

	prefer-no-csd = null;
	
	extraConfig = ''
	  //warp-mouse-to-focus;
	  gestures {
            hot-corners {
              off
            }
          }
	  hotkey-overlay {
	    skip-at-startup
	  }
	  input {
	    focus-follows-mouse max-scroll-amount="0%"
	  }
	'';


      };
    };
  };
}
