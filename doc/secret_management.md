# Managing secrets

[Agenix](https://github.com/ryantm/agenix) is a tool which uses SSH keys to
encrypt and decrypt things. My first thought was that I want to use the SSH key
on my Yubikey for this. But I also want to distribute secrets for automated
services, like the password for my backup destination, where I do not want to
confirm every access.

The keys for the different workstations need to be generated when initially
installing the system flake. But since the secrets are not yet encrypted with
the new key of this new workstation the system won't be able to decrypt
anything. To fix this the public key has to be added to the secret configuration
and the secrets have to be re-encrypted. Then the new workstation has to pull
the new encrypted version of the secrets. Only then can it decrypt anything and
operate as normal.

> In my opinion this process is acceptable. It doesn't even require any action
> on any potentially existing other workstations, since they can decrypt
> anything beforehand and will still be able to do so after adding another
> encryption key.

## Remarks

By default agenix uses SSH host or user keys. Rollbacks delete keys in these
locations. Additionally, agenix decrypts the secrets during phase 2 of the boot,
at which point the impermanence module is not ready yet. So the SSH key needs to
be in a partition which is marked as `neededForBoot` and the `identityPaths`
option has to be modified to point to that location, otherwise decrypting will
fail during boot, and agenix does not try again later.

Also be aware of which user needs the secret. Forgetting to tell agenix to set
the correct owner and group does not result in helpful error.

