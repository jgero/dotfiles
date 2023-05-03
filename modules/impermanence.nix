let
  impermanence = builtins.fetchTarball {
    url = "https://github.com/nix-community/impermanence/archive/master.tar.gz";
    sha256 = "0nnp5g40lkkmfpvmc7sfws48fji3i0nz1k6pav8vkfk8pd1wl810";
  };
in
{
  imports = [ "${impermanence}/nixos.nix" ];
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
    ];
  };
}
