{ pkgs, osConfig, lib, ... }:
with lib;
{
  config = mkIf osConfig.jgero.gnome.enable {
    dconf.settings = {
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-right = [ "<Alt>l" ];
        switch-to-workspace-left = [ "<Alt>h" ];
        move-to-workspace-right = [ "<Shift><Alt>l" ];
        move-to-workspace-left = [ "<Shift><Alt>h" ];
        switch-to-workspace-1 = [ "<Alt>1" ];
        switch-to-workspace-2 = [ "<Alt>2" ];
        switch-to-workspace-3 = [ "<Alt>3" ];
        switch-to-workspace-4 = [ "<Alt>4" ];
        move-to-workspace-1 = [ "<Shift><Alt>1" ];
        move-to-workspace-2 = [ "<Shift><Alt>2" ];
        move-to-workspace-3 = [ "<Shift><Alt>3" ];
        move-to-workspace-4 = [ "<Shift><Alt>4" ];
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = 3210;
        night-light-schedule-automatic = false;
        night-light-schedule-from = 0;
        night-light-schedule-to = 0;
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "terminal";
        command = "kitty --start-as=maximized";
        binding = "<Alt>Return";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "quicknote";
        command = "kitty --start-as=maximized quicknote";
        binding = "<Alt>n";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
    };
  };
}
