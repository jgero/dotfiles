let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILULHj3/gAxtAorfFqsmWBNePbuKsI2ekBAZ0UMOA7Qv";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINm11FfQdzFVN5uKHIP7JJaN0FmLzMAsibaCo04135KC";
in
{
  "yubipin.age".publicKeys = [ nixps nixpad ];
  "restic-password.age".publicKeys = [ nixps nixpad ];
  "backup-server-ssh-identity.age".publicKeys = [ nixps nixpad ];
}
