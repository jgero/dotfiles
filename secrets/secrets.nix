let
  nixps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEt2OGDSgD6wMWQ2nDTnZRK3M7io8Vc93iiTcNNjnhM root@nixps";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJFr/KSbiK5dPChL6yW6Q8Du2/o1DYARxm13vQ7Jn6F";
  workpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdpTTiQyMvW3u6kK2rW53AiRd3aVQCXBrAMU4H016Jo";
  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1ioWmfKl0ljM4ZZtLV/xPLHmhIG5O3QljFAq+BDzal dotfiles backup key";
  all = [ nixps nixpad workpad backup ];
in
{
  "yubipin.age".publicKeys = all;
  "restic-password.age".publicKeys = [ nixps ];
  "backup-env.age".publicKeys = [ nixps ];
  "sg-access-token.age".publicKeys = all;
}
