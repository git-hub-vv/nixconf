{ self, inputs, ... }: {
  flake.nixosModules.kde = { pkgs, lib, ... }: {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };

# perSystem = { pkgs, lib, self', ... }: {
#   packages.kde = inputs.wrapper-modules.wrappers.kde.wrap {
#     inherit pkgs;
#
#   };
# };
}
