{ pkgs, ... }: {
  # zsh needs to be enabled before it can be used as default shell
  programs.zsh.enable = true;
  users.users.jgero = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
    # generate hashed password with:
    # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
    initialHashedPassword = "$6$DhUaJBDqSjzz5mGA$e2/Ru9Bm8ruIr7XnCgB0BvoKERGzivi/96.i8QzqIJtNCCygsDzY9yH8VqoQuXppTZLydjVCI55i.gGWFqEvd.";
  };
}
