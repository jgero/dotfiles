let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkWdIXDnAaouV+bA6e5BxwqyNVD7kWgaYFhEmHRXoQF jgero@nixps";
in
{
  "yubipin.age".publicKeys = [ nixps ];
  "restic-password.age".publicKeys = [ nixps ];
}
