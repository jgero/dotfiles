let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILULHj3/gAxtAorfFqsmWBNePbuKsI2ekBAZ0UMOA7Qv";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4TGEWC/RlYrPhSHpgWP9Ugr71rnrP58x8m9KmsQvob";
in
{
  "yubipin.age".publicKeys = [ nixps nixpad ];
  "restic-password.age".publicKeys = [ nixps nixpad ];
  "backup-server-ssh-identity.age".publicKeys = [ nixps nixpad ];
}
