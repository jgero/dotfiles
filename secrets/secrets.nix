let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILULHj3/gAxtAorfFqsmWBNePbuKsI2ekBAZ0UMOA7Qv";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJFr/KSbiK5dPChL6yW6Q8Du2/o1DYARxm13vQ7Jn6F";
  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1ioWmfKl0ljM4ZZtLV/xPLHmhIG5O3QljFAq+BDzal dotfiles backup key";
  all = [ nixps nixpad backup ];
in
{
  "yubipin.age".publicKeys = all;
  "restic-password.age".publicKeys = all;
  "backup-server-ssh-identity.age".publicKeys = all;
}
