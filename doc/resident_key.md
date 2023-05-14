# Resident SSH key

Yubikeys (and other FIDO2 keys for that matter) have the capability of storing
SSH-keys. This works by generating the key onto the FIDO2 slot on the Yubikey,
which the SSH agent just references.

> To set this up the key needs its PIN. In my case previous usage did not
> require me to set that PIN up, which made me worry that the already stored
> items get lost when creating the PIN. But everything went fine.

There is a few tools to set the PIN and manage other things on a Yubikey, I used
the nix `yubikey-manager-qt` to set the PIN and `yubikey-manager` to list and
delete FIDO2 credentials of failed attempts.

> `ykman fido credentials list` and `ykman fido credentials delete <id>` to
> delete an item

Generating the SSH key onto the Yubikey is easy, and does not require any
additional tools. There are a lot of guides online, but I used [the official one
by Yubico](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html). The
relevant parts are in the 'Discoverable key instructions'.

Once the key is generated the local files on the system can be deleted,
everything of importance regarding the resident key is stored on the Yubikey. It
can be 'generated' again from the Yubikey with `ssh-keygen -K`.

When importing the SSH key from the Yubikey the biggest pitfall which I
struggled with is that the local SSH agent needs to be running, which it didn't
for a long time in my case. It has to be started with `eval "$(ssh-agent -s)"`,
which I added to my zshrc.

After that is done it is just a simple `ssh-add -K`, which tells the SSH agent
to import the key from a FIDO2 device. The key will only be added for this agent
session, which means this will have to be done regularly. When adding or using
the key you will be prompted for the PIN and touch, depending on what you
specified when originally generating the SSH key onto the Yubikey.

