{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  custom-sddm-background = pkgs.runCommand "background-image" { } ''
    cp ${./assets/sddm-background.png} $out
  '';
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "japanese_aesthetic";
    themeConfig = {
      Background = custom-sddm-background;
      HeaderTextColor = "#5c729d";
      DateTextColor = "#ffffff";
      TimeTextColor = "#ffffff";
      LoginFieldBackgroundColor = "#fbf1c7";
      PasswordFieldBackgroundColor = "#fbf1c7";
      LoginFieldTextColor = "#ffffff";
      PasswordFieldTextColor = "#ffffff";
      UserIconColor = "#ffffff";
      PasswordIconColor = "#ffffff";
      LoginButtonBackgroundColor = "#242731";
      SystemButtonsIconsColor = "#ffffff";
      SessionButtonTextColor = "#ffffff";
      VirtualKeyboardButtonTextColor = "#ffffff";
    };
  };
in
{
  #programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  #];
  # programs.firefox.enable = true;

  programs.gamemode.enable = lib.mkDefault true;
  programs.niri.enable = true;
  programs.dconf.enable = true;
  programs.light.enable = true;

  environment.sessionVariables = {
    NH_OS_FLAKE = "/etc/nixos";
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    #package = inputs.nh.packages.${pkgs.system}.default;
  };

  programs.steam = {
    enable = true; # install steam
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      # package = pkgs.kdePackages.sddm;
      wayland.enable = true;
      extraPackages = with pkgs; [
        # kdePackages.qtsvg
        # kdePackages.qtmultimedia
        # kdePackages.qtvirtualkeyboard
        custom-sddm-astronaut
        qt6.qtsvg
        qt6.qtmultimedia
        qt6.qtvirtualkeyboard
        qt6.qtdeclarative
      ];
      theme = "sddm-astronaut-theme";
    };
  };
  programs.dconf.profiles.user.databases = [
    { settings."org/gnome/desktop/interface".color-scheme = "prefer-dark"; }
  ];

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    custom-sddm-astronaut
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
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];
}
