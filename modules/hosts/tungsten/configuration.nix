{ self, inputs, ... }: {

  flake.nixosModules.host-tungsten = {
 pkgs, lib, ... }:

{
  imports =
    [ 
      #./hardware-configuration.nix
      self.nixosModules.niri
      self.nixosModules.desktop
      self.nixosModules.game
      self.nixosModules.base
      self.nixosModules.vv
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-f4bf2d83-f380-47e7-b854-3beacff91e0e".device = "/dev/disk/by-uuid/f4bf2d83-f380-47e7-b854-3beacff91e0e";
  networking.hostName = "tungsten"; # Define your hostname.

  networking.networkmanager.enable = true;

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
  #hardware.opengl.extraPackages32 = with pkgs.drivers; [
  #  mesa
  #];

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];



  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
  };



  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    mesa
    clinfo
    pulseaudioFull
   ];

  system.stateVersion = "25.11"; # read documentation before changing
};
}
