{ pkgs, pkgs-unstable, osConfig, ... }:
let
  compress-vid-dir = pkgs.writeScriptBin "compress-vid-dir" ''
    for file in *; do
        if [ -f "$file" ]; then
            new_location=$(echo "$file" | sed -r 's/.*VID_([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{6})\.mp4.*/\1_\2_\3_\4.mp4/')
            ffmpeg -i "$file" -vcodec libx264 -crf 24 "$new_location"
        fi
    done
  '';
  encode-vid = pkgs.writeScriptBin "encode-vid" ''
    ffmpeg -i "$1" -vcodec libx264 -crf 24 "$2"
  '';
in
{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.username = "jgero";
  home.homeDirectory = "/home/jgero";

  home.packages = with pkgs; [
    bitwarden
    signal-desktop
    firefox-wayland
    thunderbird
    libreoffice
    gimp
    element-desktop
    zathura
    eog
    vlc
    (inkscape-with-extensions.override {
      inkscapeExtensions = with pkgs-unstable.inkscape-extensions; [
        silhouette
        inkstitch
      ];
    })
    nextcloud-client
    jameica

    ripgrep
    fd
    tree
    wl-clipboard
    ffmpeg
    imagemagick
    pdfgrep
    killall
    unzip
    pdfcpu
    xdg-utils

    compress-vid-dir
    encode-vid
  ] ++ osConfig.jgero.packages.home;

  imports = [
    ./waybar
    ./fzf.nix
    ./git.nix
    (import ./kitty.nix { inherit pkgs; hideBorder = true; background = osConfig.jgero.colors.background; })
    ./mako.nix
    ./secrets.nix
    ./shell.nix
    ./ssh.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./task.nix
    ./tmux.nix
    ./wofi.nix
    ./xdg.nix
  ];
}
