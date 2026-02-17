{ pkgs, ... }:
{
  services.displayManager = {
    enable = true;
    sddm = {
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
}
