{ pkgs, osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.hyprland.enable {
    programs.waybar = {
      enable = true;
      # experimental flag is necessary for wlr workspaces module
      package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
      });
      systemd.enable = true;
      settings = {
        foo = {
          layer = "top";
          modules-left = [ "wlr/workspaces" "hyprland/submap" ];
          modules-center = [ "clock" ];
          # add: bluetooth, sound, wifi, cpu, mem, temp, brightness
          modules-right = [ "battery" ];

          # modules
          "wlr/workspaces" = {
            format = "{icon}";
          };
          "hyprland/submap" = {
            format = "SUB: {}";
            max-length = 15;
            tooltip = false;
          };
          clock = {
            format = "{:%A | %F | %H:%M}";
          };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "BAT: {capacity}%";
          };
        };
      };
      style = ./bar.css;
    };
  };
}
