{ pkgs, ... }:
{

  fonts.enableDefaultPackages = false;
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Maple Mono CN" ];
    };
    antialias = true;
    hinting = {
      enable = true;
      autohint = false; # Set to true if you prefer autohinting
      style = "slight"; # "slight", "medium", or "full"
    };
    subpixel = {
      rgba = "rgb"; # Use "vrgb" for vertical monitors
      lcdfilter = "default";
    };
    allowBitmaps = true;
    useEmbeddedBitmaps = true;
  };
  fonts.packages = with pkgs; [
    maple-mono.CN
    nerd-fonts.symbols-only
  ];
}
