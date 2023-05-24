{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jgero.gnome;
in
{
  options.jgero.gnome = {
    enable = mkEnableOption "gnome desktop environment";
    default = false;
  };
  config = mkIf (cfg.enable)
    {
      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
      programs.dconf.enable = true;
      environment.gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-console
      ]) ++ (with pkgs.gnome; [
        cheese
        gnome-music
        gnome-maps
        gnome-terminal
        epiphany
        geary
        gnome-characters
        gnome-weather
        gnome-contacts
      ]);
    };
}
