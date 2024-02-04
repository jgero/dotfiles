{ pkgs, ... }: {
  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";
    events = [
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock"; }
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
      { event = "after-resume"; command = "${pkgs.sway}/bin/swaymsg \"output * toggle\""; }
    ];
    timeouts = [
      { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock"; }
      { timeout = 1200; command = "${pkgs.sway}/bin/swaymsg \"output * toggle\""; }
    ];
  };
}
