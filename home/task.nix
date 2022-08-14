{
  programs.taskwarrior = {
    enable = true;
    dataLocation = "~/sync/.task";
    config = {
      verbose = "blank,footnote,label,new-id,new-uuid,affected,edit,special,project,sync,unwait,recur";
    };
  };
}
