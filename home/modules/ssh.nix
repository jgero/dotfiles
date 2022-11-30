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
      "gitlab.com" = {
        identityFile = "~/.ssh/id_gitlab";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_github";
      };
    };
  };
}
