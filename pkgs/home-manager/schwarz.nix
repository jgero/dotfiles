{ self, nixpkgs, home-manager, ... }:
let
  system = "aarch64-darwin";
  user = "geroldj";
  myNeovimOverlay = final: prev: {
    neovim = self.packages.${system}.neovim;
  };
  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
    overlays = [ myNeovimOverlay ];
  };
in
{
  homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      {
        home.username = user;
        home.homeDirectory = "/Users/${user}";
        home.stateVersion = "25.05";
        home.sessionVariables = { EDITOR = "nvim"; };

        programs.home-manager.enable = true;
        programs.zsh.enable = true;
        programs.tmux.shell = "/bin/zsh";

        home.packages = with pkgs; [
          neovim
          ripgrep
        ];

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nix.package = pkgs.nix;

        imports = [
          ../../home/tmux.nix
          (import ../../home/kitty.nix { inherit pkgs; hideBorder = false; background = "#181a1f"; })
          ../../home/shell.nix
          ../../home/fzf.nix
        ];
      }
    ];
  };
}
