{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jgero.backup;
in
{
  options.jgero.backup = {
    enable = mkEnableOption "restic backup";
  };
  config = mkIf (cfg.enable)
    {
      services.restic.backups.jgero = {
        repository = "s3:https://s3.hidrive.strato.com/restic-backups";
        paths = [ "/home/jgero/data" "/home/jgero/media" ];
        passwordFile = config.age.secrets.resticPw.path;
        environmentFile = config.age.secrets.backupEnv.path;
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
          "--keep-yearly 3"
        ];
      };
    };
}
