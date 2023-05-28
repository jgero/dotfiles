{ pkgs, osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        # highres and scaling 1 is important to fix wayland scaling issues
        monitor=,highres,auto,1

        $mod = ALT
        $mod2 = SUPER

        # jump
        bind = $mod,1,workspace,1
        bind = $mod,2,workspace,2
        bind = $mod,3,workspace,3
        bind = $mod,4,workspace,4
        bind = $mod,5,workspace,5
        bind = $mod,L,workspace,+1
        bind = $mod,H,workspace,-1

        # move
        bind = $mod SHIFT,1,movetoworkspace,1
        bind = $mod SHIFT,2,movetoworkspace,2
        bind = $mod SHIFT,3,movetoworkspace,3
        bind = $mod SHIFT,4,movetoworkspace,4
        bind = $mod SHIFT,5,movetoworkspace,5
        bind = $mod SHIFT,L,movetoworkspace,+1
        bind = $mod SHIFT,H,movetoworkspace,-1
        bind = $mod,Q,killactive,

        # focus
        bind = $mod2,B,submap,focus
        submap = focus
        bind = ,H,movefocus,l
        bind = ,L,movefocus,r
        bind = ,K,movefocus,u
        bind = ,J,movefocus,d
        bind = ,escape,submap,reset
        submap = reset

        # launch
        bind = $mod, SPACE, exec, ${pkgs.wofi}/bin/wofi --show=drun
        # terminal
        bind = $mod, Return, exec, kitty

        # bar
        exec-once=${pkgs.waybar}/bin/waybar
      '';
    };
  };
}
