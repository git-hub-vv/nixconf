{ self, inputs, ... }: {
  flake.nixosModules.desktop = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      ghostty
      mullvad-browser
      chromium
      (logseq.override { electron = electron_39; })

      qmk
      via
      qmk-udev-rules
    ];

    hardware.keyboard.qmk.enable = true;
  };
}
