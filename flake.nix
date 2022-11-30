{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@ { nixpkgs, home-manager, nixos-hardware }: {
    nixosConfigurations = {
      nixps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.dell-xps-13-7390
          ./systems/xps.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jgero = import ./home/desktop.nix;
          }
        ];
      };
      wsl = nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          modules = [
            ./systems/wsl.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = import ./home/terminal.nix;
            }
          ];
        };
    };
  };
}
