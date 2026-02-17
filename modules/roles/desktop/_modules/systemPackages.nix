{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    home-manager
    git
    nixfmt
    networkmanagerapplet
    unzip
    htop
    wineWow64Packages.stable
    nemo
    xwayland-satellite
    winetricks
    snapper
    kdePackages.qt6ct
    virtualglLib
    btrfs-progs
    protonplus
    adwaita-icon-theme
    vulkan-tools
    vulkan-loader
    lutris
    wget
  ];
}
