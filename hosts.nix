{ pkgs, nixos-hardware }: [
  {
    name = "nixps";
    nixosModules = [
      nixos-hardware.nixosModules.dell-xps-13-7390
      ./hardware/xps_2020.nix
      {
        jgero = {
          user.email = "git+commit@jgero.me";
          network = {
            hostname = "nixps";
            hostid = "5e13b1e5";
          };
          backup.enable = true;
          keyboard.no-caps = true;
        };
      }
      (import ./disko-config.nix { disk = "/dev/nvme0n1"; })
    ];
  }
  {
    name = "nixpad";
    nixosModules = [
      ./hardware/thinkpad_2023.nix
      {
        jgero = {
          user.email = "git+commit@jgero.me";
          network = {
            hostname = "nixpad";
            hostid = "9a102409";
          };
          keyboard.no-caps = true;
        };
      }
      (import ./disko-config.nix { disk = "/dev/sda"; })
    ];
  }
  {
    name = "workpad";
    nixosModules = [
      ./hardware/work_pad_l590.nix
      {
        jgero = {
          network = {
            hostname = "workpad";
            hostid = "69666999";
          };
          keyboard.no-caps = true;
          packages.home = with pkgs; [
            teams-for-linux
            (with jetbrains; (plugins.addPlugins idea-community [ "ideavim" ]))
          ];
          user.email = "johannes.gerold@fntsoftware.com";
          virt.dockerCompat = true;
        };
      }
      (import ./disko-config.nix { disk = "/dev/nvme0n1"; })
    ];
  }
]
