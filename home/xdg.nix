{ config, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      download = "/tmp/downloads";
    }
    // builtins.listToAttrs (map (name: { inherit name; value = "${config.home.homeDirectory}/media"; }) [ "music" "pictures" "videos" ])
    // builtins.listToAttrs (map (name: { inherit name; value = "${config.home.homeDirectory}/data"; }) [ "documents" "templates" ]);
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "text/plain" = "nvim.desktop";

        "application/pdf" = "org.pwmt.zathura.desktop";

        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

        "video/mp4" = "vlc.desktop";

        "image/png" = "org.gnome.eog.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
      };
    };
  };
}
