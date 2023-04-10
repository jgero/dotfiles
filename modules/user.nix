{ pkgs, ... }: {
  users.users.jgero = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "password";
  };
}
