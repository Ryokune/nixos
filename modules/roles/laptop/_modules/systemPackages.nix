{ pkgs, lib, ... }:
{
  # TODO: Move individual PKGS into their own files incase of needing to "wrap" them.
  # Just need to learn more about the nix ecosystem to figure out a good way to do this.
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     lutris = prev.lutris.override {
  #       buildFHSEnv =
  #         args:
  #         prev.buildFHSEnv (
  #           args
  #           // {
  #             extraBwrapArgs = (args.extraBwrapArgs or [ ]) ++ [
  #               "--cap-add"
  #               "ALL"
  #             ];
  #           }
  #         );
  #     };
  #   })
  # ];
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
