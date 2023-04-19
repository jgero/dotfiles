{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    curl
    restic
  ];
}
