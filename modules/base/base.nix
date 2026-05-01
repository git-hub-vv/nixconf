{ self, inputs, ... }: {
  flake.nixosModules.base = { pkgs, lib, ... }: {

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
      git
      tree
      btop
    ];

    nixpkgs.config.allowUnfree = true;
  
    time.timeZone = "Europe/Berlin";

    i18n.defaultLocale = "en_US.UTF-8";


  };
}
