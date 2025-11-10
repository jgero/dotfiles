{ config, pkgs, osConfig, lib, ... }:
{
  wayland.windowManager.sway =
    let
      quicknote = import ../pkgs/quicknote.nix { inherit pkgs; };
      ocr = import ../pkgs/screenshot-ocr.nix { inherit pkgs; };
      wallpaper = builtins.fetchurl {
        url = "https://live.staticflickr.com/65535/51615066903_205139d85e_o_d.png";
        sha256 = "15yii4zlx422d2fdl3wpz6a4faflzqam18kn7sbr9rmxlflcj2iw";
      };
      cfg = config.wayland.windowManager.sway.config;
      modeSettings = "(n)etwork (b)luetooth (s)ound (d)isplay";
      modeShutdown = "(h)ibernate (l)ock (r)eboot (s)uspend (p)oweroff";
    in
    {
      enable = true;
      extraConfig = ''
        for_window [title="floating_shell"] floating enable, border pixel 1, sticky enable
        for_window [title="dmenu"] floating enable, border pixel 1, sticky enable
      '';
      config = {
        modifier = "Mod1";
        terminal = "kitty";
        menu = "${pkgs.wofi}/bin/wofi --show=drun";
        output = {
          "*" = {
            bg = "${wallpaper} fill";
          };
        };
        gaps = {
          inner = 6;
          smartBorders = "off";
        };
        fonts.names = [ "JetBrainsMono" ];
        window = {
          border = 1;
        };
        floating = {
          border = 1;
        };
        colors = {
          focused = {
            border = "${osConfig.jgero.colors.foreground}";
            background = "${osConfig.jgero.colors.foreground}";
            text = "${osConfig.jgero.colors.background}";
            indicator = "${osConfig.jgero.colors.background}";
            childBorder = "${osConfig.jgero.colors.foreground}";
          };
          focusedInactive = {
            border = "${osConfig.jgero.colors.foreground}";
            background = "${osConfig.jgero.colors.foreground}";
            text = "${osConfig.jgero.colors.background}";
            indicator = "${osConfig.jgero.colors.background}";
            childBorder = "${osConfig.jgero.colors.foreground}";
          };
          unfocused = {
            border = "${osConfig.jgero.colors.background}";
            background = "${osConfig.jgero.colors.background}";
            text = "${osConfig.jgero.colors.foreground}";
            indicator = "${osConfig.jgero.colors.foreground}";
            childBorder = "${osConfig.jgero.colors.background}";
          };
          urgent = {
            border = "#8C3D2B";
            background = "#F26A4B";
            text = "#cccccc";
            indicator = "#cccccc";
            childBorder = "#8C3D2B";
          };
        };
        bars = [ ]; # managed as systemd user unit
        input = {
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
          "type:keyboard" = {
            xkb_layout = "us,de";
            xkb_options = lib.mkIf (osConfig.jgero.keyboard.no-caps) "caps:escape";
          };
        };
        keybindings = {
          # Basics
          "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
          "${cfg.modifier}+q" = "kill";
          "${cfg.modifier}+space" = "exec ${cfg.menu}";
          "${cfg.modifier}+Control+r" = "reload";

          "${cfg.modifier}+tab" = "workspace back_and_forth";

          # Moving
          "${cfg.modifier}+Shift+${cfg.right}" = "move container to workspace next, workspace next";
          "${cfg.modifier}+Shift+${cfg.left}" = "move container to workspace prev, workspace prev";
          "${cfg.modifier}+${cfg.left}" = "workspace prev";
          "${cfg.modifier}+${cfg.right}" = "workspace next";

          # Workspaces
          "${cfg.modifier}+1" = "workspace number 1";
          "${cfg.modifier}+2" = "workspace number 2";
          "${cfg.modifier}+3" = "workspace number 3";
          "${cfg.modifier}+4" = "workspace number 4";
          "${cfg.modifier}+5" = "workspace number 5";
          "${cfg.modifier}+6" = "workspace number 6";
          "${cfg.modifier}+7" = "workspace number 7";
          "${cfg.modifier}+8" = "workspace number 8";
          "${cfg.modifier}+9" = "workspace number 9";
          "${cfg.modifier}+0" = "workspace number 10";
          # Workspaces
          "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
          "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
          "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
          "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
          "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
          "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
          "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
          "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
          "${cfg.modifier}+Shift+9" = "move container to workspace number 9";
          "${cfg.modifier}+Shift+0" = "move container to workspace number 10";

          # Shutdown mode
          "Mod4+l" = "mode \"${modeShutdown}\"";
          "Mod4+s" = "mode \"${modeSettings}\"";

          # Screenshot mode
          "${cfg.modifier}+Shift+s" = "exec ${pkgs.sway}/bin/swaymsg mode default && ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
          "${cfg.modifier}+Shift+t" = "exec ${pkgs.sway}/bin/swaymsg mode default && ${ocr}/bin/screenshot-ocr";

          "Mod4+space" = "exec ${pkgs.sway}/bin/swaymsg input $(${pkgs.sway}/bin/swaymsg -t get_inputs --raw | ${pkgs.jq}/bin/jq '[.[] | select(.type == \"keyboard\")][0] | .identifier') xkb_switch_layout next";
          "${cfg.modifier}+n" = "exec kitty --detach -T floating_shell ${pkgs.bash}/bin/bash -c ${quicknote}/bin/quicknote";

          # Multimedia Keys
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        };
        modes = {
          "${modeShutdown}" = {
            "h" = "exec ${pkgs.systemd}/bin/systemctl hibernate && ${pkgs.sway}/bin/swaymsg mode default";
            "l" = "exec ${pkgs.swaylock}/bin/swaylock && ${pkgs.sway}/bin/swaymsg mode default";
            "r" = "exec ${pkgs.systemd}/bin/systemctl reboot && ${pkgs.sway}/bin/swaymsg mode default";
            "s" = "exec ${pkgs.systemd}/bin/systemctl suspend && ${pkgs.sway}/bin/swaymsg mode default";
            "p" = "exec ${pkgs.systemd}/bin/systemctl poweroff && ${pkgs.sway}/bin/swaymsg mode default";
            Escape = "mode default";
            Return = "mode default";
          };
          "${modeSettings}" = {
            "n" = "exec ${pkgs.sway}/bin/swaymsg mode default && kitty --detach -T floating_shell ${pkgs.bash}/bin/bash -c nmtui";
            "b" = "exec ${pkgs.sway}/bin/swaymsg mode default && kitty --detach -T floating_shell ${pkgs.bash}/bin/bash -c ${pkgs.bluetuith}/bin/bluetuith";
            "s" = "exec ${pkgs.sway}/bin/swaymsg mode default && kitty --detach -T floating_shell ${pkgs.bash}/bin/bash -c ${pkgs.pulsemixer}/bin/pulsemixer";
            "d" = "exec ${pkgs.sway}/bin/swaymsg mode default && exec ${pkgs.nwg-displays}/bin/nwg-displays";
            Escape = "mode default";
            Return = "mode default";
          };
        };
      };
    };
}
