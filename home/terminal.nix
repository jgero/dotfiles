{ pkgs, ... }: {
  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    wget
    xclip
    fzf
    ripgrep
    git
    gradle
    jdk
    cargo
    rustc
  ];

  imports = [
    ./modules/neovim
    ./modules/shell
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/task.nix
    ./modules/terminal.nix
    ./modules/tmux.nix
  ];
}

