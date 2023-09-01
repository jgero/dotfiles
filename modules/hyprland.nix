{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  # hyprland complains now that wlr and hyprland portal are active at the same time
  # xdg.portal.wlr.enable = true;
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
}
