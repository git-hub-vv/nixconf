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

  perSystem = { pkgs, lib, self', ... }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
	  keyboard.xkb.layout = "us,ua";
	  focus-follows-mouse = null;
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.ghostty;
          "Mod+Q".close-window = null;
	  "Mod+F".maximize-column = null;
	  "Mod+Shift+F".fullscreen-window = null;
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
	  gaps = 5;
	  focus-ring = {
	    width = 2;
	    active-color = "#F7ADF0";
	  };
	};


      };
    };
  };
}
