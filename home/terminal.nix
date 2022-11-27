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
    ../modules/neovim
    ../modules/terminal.nix
    ../modules/git.nix
    ../modules/ssh.nix
    ../modules/task.nix
    ../modules/shell
    ../modules/tmux.nix
  ];
}

