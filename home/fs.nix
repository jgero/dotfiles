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
  };
}
