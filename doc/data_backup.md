# Data backup

> For the longer term I want to move to a strategy utilizing ZFS with its send,
> receive and snapshot capabilities. Backing up by dataset instead of by
> directory would allow nicer directory structure on the host

Currently backup is done with the `restic` tool, executed by systemd units.
Every night a snapshot is taken and synced to a remote repository. There is also
a on-site backup which is triggered automatically once the backup drive is
connected to the system.

Credentials for these repositories are in separate files.

