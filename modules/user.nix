{ pkgs, ... }: {
  users.users.jgero = {
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
    initialPassword = "password";
  };
}
