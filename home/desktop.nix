{ pkgs, ... }: {
  home.stateVersion = "22.05";
  xdg.enable = true;

  home.packages = with pkgs; [
    wget
    xclip
    fzf
    ripgrep
    git
    bitwarden
    signal-desktop
    firefox
    thunderbird
    gradle
    jdk
    cargo
    rustc
    libreoffice
    gimp
    gnome.gnome-boxes
  ];

  imports = [
    ./modules/neovim
    ./modules/shell
    ./modules/git.nix
    ./modules/gnome_dconf.nix
    ./modules/ssh.nix
    ./modules/task.nix
    ./modules/terminal.nix
    ./modules/tmux.nix
  ];
}

