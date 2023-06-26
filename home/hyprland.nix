{ pkgs, osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      extraConfig = ''
        input {
            kb_layout = us,de
            touchpad {
                natural_scroll = true
            }
        }
        general {
            col.active_border = 0xff5074bd
        }
        decoration {
            rounding = 5
        }
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
        bind = $mod2,B,submap,FOCUS
        submap = FOCUS
        bind = ,H,movefocus,l
        bind = ,L,movefocus,r
        bind = ,K,movefocus,u
        bind = ,J,movefocus,d
        bind = ,Return,submap,reset
        bind = ,escape,submap,reset
        submap = reset

        # session
        bind = $mod2,L,submap,SESSION
        submap = SESSION
        bind = ,L,exec,hyprctl dispatch submap reset && ${pkgs.swaylock}/bin/swaylock
        bind = ,S,exec,hyprctl dispatch submap reset && systemctl suspend
        bind = ,P,exec,hyprctl dispatch submap reset && systemctl poweroff
        bind = ,R,exec,hyprctl dispatch submap reset && systemctl reboot
        bind = ,escape,submap,reset
        submap = reset

        # resize
        bind = $mod2,R,submap,RESIZE
        submap = RESIZE
        binde = ,right,resizeactive,10 0
        binde = ,left,resizeactive,-10 0
        binde = ,up,resizeactive,0 -10
        binde = ,down,resizeactive,0 10
        bind = ,escape,submap,reset
        submap = reset

        # settings
        bind = $mod2,S,submap,SETTINGS
        submap = SETTINGS
        bind = ,N,exec,hyprctl dispatch submap reset && kitty --detach -T nmtui ${pkgs.zsh}/bin/zsh -c nmtui
        bind = ,B,exec,hyprctl dispatch submap reset && kitty --detach -T bluetuith ${pkgs.zsh}/bin/zsh -c ${pkgs.bluetuith}/bin/bluetuith
        bind = ,S,exec,hyprctl dispatch submap reset && ${pkgs.pavucontrol}/bin/pavucontrol
        bind = ,escape,submap,reset
        submap = reset
        
        # display
        bind = $mod2,D,submap,DISPLAY
        submap = DISPLAY
        bind = ,M,exec,hyprctl dispatch submap reset && hyprctl keyword monitor ",highres,auto,1,mirror,eDP-1"
        bind = ,E,exec,hyprctl dispatch submap reset && hyprctl keyword monitor ",highres,auto,1"
        bind = ,S,exec,hyprctl dispatch submap reset && hyprctl keyword monitor "eDP-1, disable"
        bind = ,R,exec,hyprctl dispatch submap reset && systemctl --user restart waybar.service
        bind = ,escape,submap,reset
        submap = reset

        exec-once = ${pkgs.swayidle}/bin/swayidle -w
        exec-once = ${pkgs.swaybg}/bin/swaybg --image /home/jgero/Pictures/galaxy_wallpaper.jpg

        # launch
        bind = $mod,SPACE,exec,${pkgs.wofi}/bin/wofi --show=drun
        # terminal
        bind = $mod,Return,exec,kitty
        bind = $mod2,SPACE,exec,hyprctl devices | ${pkgs.gnugrep}/bin/grep 'keyboard' | tr -d '\t' | xargs -I KEYBOARD hyprctl switchxkblayout KEYBOARD next
        # brightness
        bind = $mod2,up,exec,${pkgs.brightnessctl}/bin/brightnessctl set +10%
        bind = $mod2,down,exec,${pkgs.brightnessctl}/bin/brightnessctl set 10%-
        # screenshot
        bind = CTRL SHIFT,s,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)"

        # floating settings windows
        windowrule = float,title:^(nmtui|bluetuith|Volume Control)$
        windowrule = center,title:^(nmtui|bluetuith|Volume Control)$
        windowrule = size 900 500,title:^(nmtui|bluetuith|Volume Control)$
      '';
    };
  };
}
