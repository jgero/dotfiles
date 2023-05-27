{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    # experimental flag is necessary for wlr workspaces module
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    settings = {
      foo = {
        layer = "top";
        modules-left = [ "wlr/workspaces" ];
        modules-center = [ "clock" ];
        # add: bluetooth, sound, wifi, cpu, mem, temp, brightness
        modules-right = [ "battery" ];

        # modules
        "wlr/workspaces" = {
          format = "{icon}";
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
}
