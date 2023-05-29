{ pkgs, osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.hyprland.enable {
    services.swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      ];
      timeouts = [
        { timeout = 300; command = "hyprctl dispatch dpms off"; resumeCommand = "hyprctl dispatch dpms on"; }
        { timeout = 305; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      ];
    };
  };
}

