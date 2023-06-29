{ pkgs, hyprland, ... }:
let
  selectProject = pkgs.writeScriptBin "selectProject" (builtins.readFile ../scripts/zsh/selectProject.zsh);
  quicknote = pkgs.writeScriptBin "quicknote" (builtins.readFile ../scripts/zsh/quicknote.zsh);
  compressVidDir = pkgs.writeScriptBin "compressVidDir" (builtins.readFile
    ../scripts/zsh/compressVidDir.zsh);
  encodeVid = pkgs.writeScriptBin "encodeVid" (builtins.readFile
    ../scripts/zsh/encodeVid.zsh);
  pidCpu = pkgs.writeScriptBin "pidCpu" (builtins.readFile
    ../scripts/zsh/pidCpu.zsh);
  pidMem = pkgs.writeScriptBin "pidMem" (builtins.readFile
    ../scripts/zsh/pidMem.zsh);
in
{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.username = "jgero";
  home.homeDirectory = "/home/jgero";
  xdg.enable = true;

  home.packages = with pkgs; [
    bitwarden
    signal-desktop
    firefox-wayland
    thunderbird
    libreoffice
    gimp
    element-desktop
    zathura
    gnome.eog
    vlc

    fzf
    ripgrep
    fd
    tree
    wl-clipboard
    ffmpeg
    imagemagick
    pdfgrep
    killall

    selectProject
    quicknote
    compressVidDir
    encodeVid
    pidCpu
    pidMem
  ];

  imports = [
    hyprland.homeManagerModules.default
    ./git.nix
    ./gnome.nix
    ./hyprland.nix
    ./kitty.nix
    ./mako.nix
    ./ssh.nix
    ./swayidle.nix
    ./swaylock.nix
    ./task.nix
    ./tmux.nix
    ./waybar.nix
    ./wofi.nix
    ./zsh.nix
  ];
}
