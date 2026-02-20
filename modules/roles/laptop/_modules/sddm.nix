{ pkgs, ... }:
{
  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland.enable = true;
      extraPackages = with pkgs; [
        substratum.sddm-astronaut-jp
        qt6.qtsvg
        qt6.qtmultimedia
        qt6.qtvirtualkeyboard
        qt6.qtdeclarative
      ];
      theme = "sddm-astronaut-theme";
    };
  };
  environment.systemPackages = with pkgs; [
    substratum.sddm-astronaut-jp
  ];
  fonts.packages = with pkgs; [
    substratum.electroharmonix
  ];
}
