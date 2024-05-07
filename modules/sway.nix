{ pkgs, lib, ... }: {
  options.jgero = with lib; {
    colors = {
      background = mkOption {
        type = types.str;
        description = "HEX value of background color in the format of '#000000'";
      };
      foreground = mkOption {
        type = types.str;
        description = "HEX value of foreground items and text color in the format of '#000000'";
      };
    };
    keyboard = {
      no-caps = mkOption {
        type = types.bool;
        default = false;
        description = "map the capslock to escape";
      };
    };
  };
  config = {
    programs.sway.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.pam.services.swaylock = { };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
        };
      };
    };
  };
}
