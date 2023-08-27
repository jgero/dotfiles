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
      systemd.user.services =
        let
          remoteRepo = "sftp:jgero@sftp.hidrive.strato.com:/users/jgero/backups";
          localRepo = "/run/media/jgero/backup-drive/restic";
          passwordFile = config.age.secrets.resticPw.path;
          backupPaths = "/home/jgero/sync";
          keep = {
            daily = "7";
            weekly = "4";
            monthly = "6";
            yearly = "3";
          };
        in
        {
          restic_backup = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.restic}/bin/restic backup -r ${remoteRepo} --password-file ${passwordFile} --one-file-system --tag systemd.timer ${backupPaths}";
              ExecStartPost = "${pkgs.restic}/bin/restic forget -r ${remoteRepo} --password-file ${passwordFile} --tag systemd.timer --group-by \"paths,tags\" --keep-daily ${keep.daily} --keep-weekly ${keep.weekly} --keep-monthly ${keep.monthly} --keep-yearly ${keep.yearly}";
            };
            onFailure = [ "restic_unlock.service" ];
            path = [
              pkgs.openssh
            ];
          };
          restic_backup_to_harddrive = {
            after = [ "run-media-jgero-backup\\x2ddrive.mount" ];
            requires = [ "run-media-jgero-backup\\x2ddrive.mount" ];
            wantedBy = [ "run-media-jgero-backup\\x2ddrive.mount" ];
            serviceConfig = {
              ExecStart = "${pkgs.restic}/bin/restic backup -r ${localRepo} --password-file ${passwordFile} --one-file-system --tag systemd.timer ${backupPaths}";
            };
            unitConfig = {
              OnSuccess = "restic_backup.service";
            };
          };
          restic_prune = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.restic}/bin/restic -r ${remoteRepo} --password-file ${passwordFile} prune";
            };
            path = [
              pkgs.openssh
            ];
          };
          restic_unlock = {
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.restic}/bin/restic -r ${remoteRepo} --password-file ${passwordFile} unlock";
            };
            unitConfig = {
              OnSuccess = "restic_backup.service";
            };
            path = [
              pkgs.openssh
            ];
          };
        };
      systemd.user.timers = {
        restic_backup = {
          wantedBy = [ "timers.target" ];
          partOf = [ "restic_backup.service" ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        };
        restic_prune = {
          wantedBy = [ "timers.target" ];
          partOf = [ "restic_prune.service" ];
          timerConfig = {
            OnCalendar = "monthly";
            Persistent = true;
          };
        };
      };
    };
}
