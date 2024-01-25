{ nixos-hardware }: [
  {
    name = "nixps";
    nixosModules = [
      nixos-hardware.nixosModules.dell-xps-13-7390
      ./hardware/xps_2020.nix
      {
        jgero.network = {
          hostname = "nixps";
          hostid = "5e13b1e5";
        };
        jgero.backup.enable = true;
      }
    ];
  }
  {
    name = "nixpad";
    nixosModules = [
      ./hardware/thinkpad_2023.nix
      {
        jgero.network = {
          hostname = "nixpad";
          hostid = "9a102409";
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
        jgero.network = {
          hostname = "workpad";
          hostid = "69666999";
        };
      }
    ];
  }
]
