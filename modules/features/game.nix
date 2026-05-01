{ self, inputs, ... }: {
  flake.nixosModules.game = { pkgs, lib, ... }: {
    
    environment.systemPackages = with pkgs; [
      mangohud
      protonplus
    ];
    
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      extraPackages = with pkgs; [ pkgsi686Linux.libpulseaudio libpulseaudio ];
    };

    environment.sessionVariables = {
      STEAM_USE_X11 = "1";
      STEAM_NO_SANDBOX = "1";
    };

  };
}
