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
          modules-left = [ "custom/nixstore" "wlr/workspaces" "hyprland/submap" ];
          modules-center = [ "clock" ];
          modules-right = [ "hyprland/language" "network" "bluetooth" "wireplumber" "cpu" "custom/coretemp" "memory" "battery" ];

          # modules
          network = {
            format = "NET |";
            format-wifi = "NET: {essid} |";
            format-ethernet = "NET: WIRED |";
          };
          "custom/nixstore" = {
            exec = "${pkgs.coreutils}/bin/du -sh /nix/store | ${pkgs.gnused}/bin/sed 's/\\([0-9]\\+[A-Z]\\+\\).*/\\1/'";
            interval = 300;
            format = "STORE: {}";
            tooltip = false;
          };
          "custom/coretemp" = {
            exec = "${pkgs.lm_sensors}/bin/sensors | ${pkgs.gnugrep}/bin/grep 'Package id 0:' | ${pkgs.gnused}/bin/sed 's/^Package id 0:  +//' | ${pkgs.gnused}/bin/sed 's/\\.[0-9]°C[ ]\\+.*$//'";
            interval = 10;
            format = " {}°C |";
            tooltip = false;
          };
          wireplumber = {
            format = "VOL: {volume}%";
          };
          cpu = {
            format = "CPU: {usage}%";
          };
          memory = {
            format = "MEM: {percentage}%";
            tooltip = false;
          };
          bluetooth = {
            format-on = "BLUE: ON |";
            format-off = "BLUE: OFF |";
            format-connected = "BLUE: {num_connections} |";
          };
          "hyprland/language" = {
            format = "LANG: {} |";
            format-en = "EN/US";
          };
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
