let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkWdIXDnAaouV+bA6e5BxwqyNVD7kWgaYFhEmHRXoQF jgero@nixps";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4TGEWC/RlYrPhSHpgWP9Ugr71rnrP58x8m9KmsQvob";
in
{
  "yubipin.age".publicKeys = [ nixps nixpad ];
  "restic-password.age".publicKeys = [ nixps nixpad ];
  "backup-server-ssh-identity.age".publicKeys = [ nixps nixpad ];
}
