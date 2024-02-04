let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILULHj3/gAxtAorfFqsmWBNePbuKsI2ekBAZ0UMOA7Qv";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJFr/KSbiK5dPChL6yW6Q8Du2/o1DYARxm13vQ7Jn6F";
in
{
  "yubipin.age".publicKeys = [ nixps nixpad ];
  "restic-password.age".publicKeys = [ nixps nixpad ];
  "backup-server-ssh-identity.age".publicKeys = [ nixps nixpad ];
}
