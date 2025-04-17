{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip
    ];
  };
  hardware.printers = {
    ensureDefaultPrinter = "Space-2D-Printer";
    ensurePrinters = [
      {
        name = "Space-2D-Printer";
        model = "HP/hp-color_laserjet_mfp_m480-ps.ppd.gz";
        deviceUri = "socket://10.11.42.10";
      }
    ];
  };
}
