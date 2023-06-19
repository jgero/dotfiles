{ osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.hyprland.enable {
    services.mako = {
      enable = true;
      backgroundColor = "#141414";
      borderColor = "#66abde";
      borderRadius = 6;
      borderSize = 1;
      defaultTimeout = 5000;
    };
  };
}
