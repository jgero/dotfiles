{ pkgs, ... }:
let
  askpass = pkgs.writeScriptBin "askpass" (builtins.readFile
    ../scripts/zsh/askpass.zsh);
in
{
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${askpass}/bin/askpass";
  };
}
