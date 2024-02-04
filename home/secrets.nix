{ osConfig, lib, ... }:
let
  secret-package = osConfig.jgero.secrets.package;
in
{
  home.packages = lib.mkIf (!isNull secret-package) [
    secret-package
  ];
}
