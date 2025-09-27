{ self, nixpkgs, nixpkgs-unstable, disko, agenix, home-manager, nixos-hardware, ... }@inputs:
let
  lib = nixpkgs.lib;
  system = "x86_64-linux";
  myNeovimOverlay = final: prev: {
    neovim = self.packages.${system}.neovim;
  };
  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
    overlays = [ myNeovimOverlay ];
  };
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config = { allowUnfree = true; };
  };
in
{
  nixosConfigurations = builtins.listToAttrs (
    builtins.map
      (host: {
        name = host.name;
        value = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            disko.nixosModules.disko
            agenix.nixosModules.default
            {
              jgero = {
                secrets.package = agenix.packages.${system}.default;
                colors = {
                  background = "#23323f";
                  foreground = "#969591";
                };
              };
            }
            ../../modules
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jgero = import ../../home;
              home-manager.extraSpecialArgs = inputs // { inherit pkgs-unstable; };
            }
          ] ++ host.nixosModules;
          specialArgs = { inherit pkgs-unstable; };
        };
      })
      (import ./hosts.nix { inherit pkgs pkgs-unstable nixos-hardware; }));
}
