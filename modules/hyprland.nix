{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jgero.hyprland;
in
{
  options.jgero.hyprland = {
    enable = mkEnableOption "hyprland window manager";
    default = false;
  };
  config = mkIf (cfg.enable)
    {
      programs.hyprland.enable = true;
      xdg.portal.wlr.enable = true;
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
            command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          };
        };
      };
    };
}
