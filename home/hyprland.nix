{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland =
    let
      quicknote = import ../pkgs/quicknote.nix { inherit pkgs; };
      wallpaper = builtins.fetchurl {
        url = "https://my.hidrive.com/api/sharelink/download?id=lECFE2kr";
        sha256 = "1sxwsvq8d1qnimnahdyjpzb94rzycnksr4m7j1khdm3ikxz9w33a";
      };
      submaps = {
        "FOCUS" = {
          modifier = "$mod2";
          key = "B";
          bindings = [
            { key = "H"; command = "movefocus"; params = "l"; description = "left"; }
            { key = "L"; command = "movefocus"; params = "r"; description = "right"; }
            { key = "K"; command = "movefocus"; params = "u"; description = "up"; }
            { key = "J"; command = "movefocus"; params = "d"; description = "down"; }
          ];
        };
        "SESSION" = {
          modifier = "$mod2";
          key = "L";
          bindings = [
            { key = "L"; command = "exec"; params = "hyprctl dispatch submap reset && ${pkgs.swaylock}/bin/swaylock"; description = "ock"; }
            { key = "S"; command = "exec"; params = "hyprctl dispatch submap reset && systemctl suspend"; description = "uspend"; }
            { key = "P"; command = "exec"; params = "hyprctl dispatch submap reset && systemctl poweroff"; description = "oweroff"; }
            { key = "R"; command = "exec"; params = "hyprctl dispatch submap reset && systemctl reboot"; description = "eboot"; }
          ];
        };
        "RESIZE" = {
          modifier = "$mod2";
          key = "R";
          bindings = [
            { key = "H"; command = "resizeactive"; params = "-10 0"; description = "left"; repeatable = true; }
            { key = "L"; command = "resizeactive"; params = "10 0"; description = "right"; repeatable = true; }
            { key = "K"; command = "resizeactive"; params = "0 -10"; description = "up"; repeatable = true; }
            { key = "J"; command = "resizeactive"; params = "0 10"; description = "down"; repeatable = true; }
          ];
        };
        "SETTINGS" = {
          modifier = "$mod2";
          key = "S";
          bindings = [
            { key = "N"; command = "exec"; params = "hyprctl dispatch submap reset && kitty --detach -T nmtui ${pkgs.zsh}/bin/zsh -c nmtui"; description = "etwork"; }
            { key = "B"; command = "exec"; params = "hyprctl dispatch submap reset && kitty --detach -T bluetuith ${pkgs.zsh}/bin/zsh -c ${pkgs.bluetuith}/bin/bluetuith"; description = "luetooth"; }
            { key = "S"; command = "exec"; params = "hyprctl dispatch submap reset && ${pkgs.pavucontrol}/bin/pavucontrol"; description = "ound"; }
          ];
        };
        "DISPLAY" = {
          modifier = "$mod2";
          key = "D";
          bindings = [
            { key = "M"; command = "exec"; params = ''hyprctl dispatch submap reset && hyprctl keyword monitor ",highres,auto,1,mirror,eDP-1"''; description = "irror"; }
            { key = "E"; command = "exec"; params = ''hyprctl dispatch submap reset && hyprctl keyword monitor ",highres,auto,1"''; description = "xtend"; }
            { key = "S"; command = "exec"; params = ''hyprctl dispatch submap reset && hyprctl keyword monitor "eDP-1, disable"''; description = "ingle"; }
            { key = "R"; command = "exec"; params = ''hyprctl dispatch submap reset && systemctl --user restart waybar.service''; description = "eload"; }
          ];
        };
      };
    in
    {
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

        ${lib.strings.concatStringsSep "\n\n" (lib.attrsets.mapAttrsToList
        (name: value: let
          nameWithDesc = "${name} ${lib.strings.concatMapStringsSep " "
          (binding: "(${binding.key})${binding.description}")
          value.bindings}";
        in ''
        bind = ${value.modifier},${value.key},submap,${nameWithDesc}
        submap = ${nameWithDesc}
        ${lib.strings.concatMapStringsSep "\n" (binding:
          lib.strings.concatStringsSep "," [
          "bind${if binding.repeatable or false then "e" else ""} = "
          binding.key
          binding.command
          binding.params
          ]) value.bindings}
        bind = ,escape,submap,reset
        submap = reset
        ''
        ) submaps)}

        exec-once = ${pkgs.swayidle}/bin/swayidle -w
        exec-once = ${pkgs.swaybg}/bin/swaybg --image ${wallpaper}

        # launch
        bind = $mod,SPACE,exec,${pkgs.wofi}/bin/wofi --show=drun
        # terminal
        bind = $mod,Return,exec,kitty
        bind = $mod2,SPACE,exec,hyprctl devices | ${pkgs.gnugrep}/bin/grep 'keyboard' | tr -d '\t' | xargs -I KEYBOARD hyprctl switchxkblayout KEYBOARD next
        bind = $mod,N,exec,kitty ${quicknote}/bin/quicknote
        # brightness
        bind = $mod2,up,exec,${pkgs.brightnessctl}/bin/brightnessctl set +10%
        bind = $mod2,down,exec,${pkgs.brightnessctl}/bin/brightnessctl set 10%-
        # screenshot
        bind = CTRL SHIFT,s,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png

        # floating settings windows
        windowrule = float,title:^(nmtui|bluetuith|Volume Control)$
        windowrule = center,title:^(nmtui|bluetuith|Volume Control)$
        windowrule = size 900 500,title:^(nmtui|bluetuith|Volume Control)$
      '';
    };
}
