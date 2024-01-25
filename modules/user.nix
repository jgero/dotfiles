{ pkgs, ... }: {
  programs.zsh.enable = true;
  users.users.jgero = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
    initialPassword = "password";
  };
}
