{
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
}
