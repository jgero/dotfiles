{
  age.identityPaths = [ "/home/jgero/secrets/hidrive-key/id_ed25519" ];
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
}
