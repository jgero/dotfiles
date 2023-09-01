{ osConfig, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks."sftp.hidrive.strato.com" = {
      identityFile = osConfig.age.secrets.backupIdentity.path;
    };
  };
}
