{ pkgs, config, ... }:
let
  askpass = pkgs.writeScriptBin "askpass" ''
    cat ${config.age.secrets.yubipin.path}
  '';
in
{
  services.openssh.enable = true;
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${askpass}/bin/askpass";
    knownHosts = {
      "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      "sftp.hidrive.strato.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKj++KINkipb3Uh30rB+BpR0TArchTWDoetSEKpymo9o";
    };
  };
}
