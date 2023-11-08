{ disk ? "/dev/nvme0n1" }: {
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  # if you want to use the key for interactive login be sure there is no trailing newline
                  # for example use `echo -n "password" > /tmp/secret.key`
                  passwordFile = "/tmp/secret.key"; # Interactive
                  # keyFile = "/tmp/secret.key";
                };
                additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        pool = {
          type = "lvm_vg";
          lvs = {
            root = {
              end = "-16G";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/data" = {
                    mountpoint = "/data";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                # randomEncryption = true;
                resumeDevice = true; # resume from hiberation from this device
              };
            };
          };
        };
      };
    };
  };
}
