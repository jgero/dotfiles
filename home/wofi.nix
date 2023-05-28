{ pkgs, osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.hyprland.enable {
    programs.wofi = {
      enable = true;
    };
  };
}
