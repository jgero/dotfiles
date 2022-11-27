{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-22.05";
 	nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
	nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware }: {
    nixosConfigurations = {
		nixps = nixpkgs.lib.nixosSystem {
		  system = "x86_64-linux";
		  modules = [
			nixos-hardware.nixosModules.dell-xps-13-7390
		  ];
		};
	}
  };
}
