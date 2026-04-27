{ self , inputs , ... }:
{
  flake.nixosModules.vv = {
    users.users.vv = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
	"wheel"
      ];
      #uid = 1000;
    };
    home-manager = {
      useGlobalPkgs = true;
      users.vv = self.modules.homeManager.vv;
    };
  };

  flake.modules.homeManager.vv =
    {
      home = {
        username = "vv";
        homeDirectory = "/home/vv";
        stateVersion = "25.11";
      };

      gtk.colorScheme = "dark";
      #xdg.configFile."starship.toml".source = ./_dotfiles/starship.toml;
      programs.git = {
        enable = true;
	#commit.gpgSign = true;
	extraConfig = {
	  user = {
	    email = "vv@vv";
	    name = "vv";
	  };
          init.defaultBranch = "main";
	};
      };
    };
}
