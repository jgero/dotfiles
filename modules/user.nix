{ pkgs, ... }: {
  # zsh needs to be enabled before it can be used as default shell
  programs.zsh.enable = true;
  users.users.jgero = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "password";
  };
}
