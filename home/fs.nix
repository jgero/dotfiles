{ config, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "/tmp/downloads";
    }
    // builtins.listToAttrs (map (name: { inherit name; value = "${config.home.homeDirectory}/media"; }) [ "music" "pictures" "videos" ])
    // builtins.listToAttrs (map (name: { inherit name; value = "${config.home.homeDirectory}/data"; }) [ "documents" "templates" ]);
  };
  home.persistence."/data/jgero" = {
    directories = [ "data" "media" ];
    allowOther = true;
  };
  home.persistence."/nix/persist/jgero" = {
    directories = [
      "projects"
      ".config/Signal"
      ".config/Element"
      ".thunderbird"
      ".mozilla/firefox"
      ".cache/mozilla/firefox"
      ".local"
      "vm"
    ];
    allowOther = true;
  };
}
