{ lib, ... }:
with lib;
{
  options.jgero.secrets = {
    # should be added to user space packages
    package = mkOption {
      type = types.nullOr types.package;
      description = "optional binary to do secret stuff";
    };
  };
  config = {
    age.secrets.yubipin = {
      file = ../secrets/yubipin.age;
      owner = "jgero";
      group = "users";
    };
    age.secrets.resticPw = {
      file = ../secrets/restic-password.age;
      owner = "jgero";
      group = "users";
    };
    age.secrets.backupIdentity = {
      file = ../secrets/backup-server-ssh-identity.age;
      owner = "jgero";
      group = "users";
    };
  };
}
