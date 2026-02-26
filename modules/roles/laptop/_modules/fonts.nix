{ pkgs, ... }:
{

  fonts.enableDefaultPackages = false;
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Symbols Nerd Font"
        "Maple Mono NF CN"
      ];
      emoji = [
        "EmojiOne Color"
        "Noto Color Emoji"
        "Noto Emoji"
      ];
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
    nerd-fonts.symbols-only
    maple-mono.NF-CN
    nanum
  ];
}
