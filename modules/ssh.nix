{ pkgs, config, ... }:
let
  askpass = pkgs.writeScriptBin "askpass" ''
    cat ${config.age.secrets.yubipin.path}
  '';
in
{
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${askpass}/bin/askpass";
  };
}
