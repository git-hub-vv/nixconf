{ self, inputs, ... }:
{
  flake.nixosConfigurations.tungsten = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [ 
      self.nixosModules.host-tungsten 
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}

