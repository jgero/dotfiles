{
  programs.ssh = {
    enable = true;
    matchBlocks."sftp.hidrive.strato.com" = {
      identityFile = "/home/jgero/secrets/hidrive-key/id_ed25519";
    };
  };
}
