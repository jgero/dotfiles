{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "git.sr.ht" = {
        identityFile = "~/.ssh/id_srht";
      };
    };
  };
}
