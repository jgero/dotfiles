{ pkgs, lib, ... }: {
  options.jgero.colors = with lib; {
    background = mkOption {
      type = types.str;
      description = "HEX value of background color in the format of '#000000'";
    };
    foreground = mkOption {
      type = types.str;
      description = "HEX value of foreground items and text color in the format of '#000000'";
    };
  };
  config = {
    programs.sway.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
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
