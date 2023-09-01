{ config, ... }: {
  programs.taskwarrior = {
    enable = true;
    dataLocation = "${config.xdg.userDirs.documents}/taskwarrior";
    config = {
      verbose = "blank,footnote,label,new-id,new-uuid,affected,edit,special,project,sync,unwait,recur";
    };
  };
}
