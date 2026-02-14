{ pkgs, ... }:
let
  electroharmonix-font = pkgs.stdenvNoCC.mkDerivation {
    pname = "electroharmonix-font";
    version = "1.0";

    src = ./assets/Electroharmonix.otf;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp $src $out/share/fonts/opentype/
    '';
  };
in
{
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
    electroharmonix-font
    maple-mono.CN
    nerd-fonts.symbols-only
  ];
}
