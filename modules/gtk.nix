{
  environment.etc = {
    "xdg/gtk-2.0/gtkrc".text = "gtk-application-prefer-dark-theme=1";
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
    '';
  };
}

