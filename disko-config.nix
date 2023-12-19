# run with mode 'disko' and --arg disk '"/dev/sda"'

{ disk ? "/dev/nvme0n1", ... }: {
  disko.devices = {
    disk = {
      slot_0 = {
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
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
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
            swap = {
              size = "16G";
              content = {
                type = "swap";
                # randomEncryption = true;
                resumeDevice = true; # resume from hiberation from this device
              };
            };
            root = {
              size = "100%FREE";
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
          };
        };
      };
  };
}
