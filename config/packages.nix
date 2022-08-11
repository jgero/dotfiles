{ config, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    wget
    xclip
    fzf
    ripgrep
    git
    bitwarden
    signal-desktop
    restic
  ];
}
