{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "git.sr.ht" = {
        identityFile = "~/.ssh/id_srht";
      };
      "sftp.hidrive.strato.com" = {
        identityFile = "~/.ssh/id_hidrive";
      };
    };
  };
}
