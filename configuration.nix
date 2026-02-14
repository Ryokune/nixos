# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./impermanence.nix
    ./users.nix
    ./tlp.nix
    ./system-programs.nix
    ./fonts.nix
  ];
  zramSwap = {
    enable = true;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Favor RAM over swap
    "vm.vfs_cache_pressure" = 50; # Keep inode/dentry caches longer
  };
  services.scx.enable = lib.mkDefault true;
  services.scx.scheduler = lib.mkDefault "scx_bpfland";
  services.waydroid.enable = lib.mkDefault true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
  networking = {
    firewall = {
      enable = true;
    };
    nftables.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  # hardware.cpu.intel.updateMicrocode = true;
  security.rtkit.enable = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  boot.kernelModules = [ "ntsync" ];

  # systemd.user.services."hm-activate" = {
  #   description = "Home Manager activation for all users.";
  #
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "%h/.local/state/nix/profiles/home-manager/activate";
  #     Environment = [
  #       "PATH=/run/current-system/sw/bin"
  #     ];
  #   };
  #
  #   wantedBy = [ "default.target" ];
  # };
  # home-manager.users.fish = import ./home/fish.nix;
  boot.kernelParams = [
    # "acpi_backlight=video"
    "psi=1"
    "pcie_aspm=off"
    "intel_iommu=igfx_off"
    # "systemd.unified_cgroup_hierarchy=0"
    # "SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1"
    # "i915.enable_psr=0"
  ];

  security.protectKernelImage = true;
  nix.settings.use-xdg-base-directories = true;

  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 10d";
  # };

  #systemd.user.services.nix-clean = {
  #  description = "Clean user-level Nix generations";
  #  serviceConfig.Type = "oneshot";
  #  script = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
  #  startAt = "weekly";
  #};

  nixpkgs.config.allowUnfree = true;
  security.sudo.extraConfig = "Defaults lecture=never";
  services.journald.storage = "persistent";
  networking.networkmanager.settings.connectivity = {
    enabled = true;
    uri = "http://connectivity-check.ubuntu.com/";
    interval = 30;
  };
  # environment.etc."NetworkManager/conf.d/00-connectivity.conf".text = ''
  #   [connectivity]
  #   enabled=true
  #   uri=https://fedoraproject.org/static/hotspot.txt
  #   response=OK
  #   interval=30
  # '';
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "20-waybar-nm" ''
        # Called when interface changes
        if [ "$2" = "connectivity-change" ]; then
            ${pkgs.procps}/bin/pkill -RTMIN+3 waybar 2>/dev/null
        fi
        exit 0
      '';
      type = "basic";
    }
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "siesta"; # Define your hostname.

  environment.sessionVariables = {
    # QT_QPA_PLATFORMTHEME = "qt6ct";
    HOSTNAME = config.networking.hostName;
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  #time.timeZone = "UTC";
  time.timeZone = "Asia/Manila";
  i18n.defaultLocale = "en_US.UTF-8";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  #systemd.extraConfig = "DefaultLimitNOFILE=524288";
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };
  security.pam.loginLimits = [
    {
      domain = "fish";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service

  boot.tmp.cleanOnBoot = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  services.snapper.persistentTimer = true;
  services.snapper.snapshotInterval = "daily";
  services.snapper = {
    configs = {
      # Snapshots for your persistent system data
      persist = {
        SUBVOLUME = "/persist";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_YEARLY = 0;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_HOURLY = 0;
        TIMELINE_LIMIT_DAILY = 10;

      };
      # Snapshots for your user data
      # home = {
      #   SUBVOLUME = "/home";
      #   TIMELINE_CREATE = false;
      #   TIMELINE_CLEANUP = true;
      #   ALLOW_USERS = [ "fish" ];
      #   TIMELINE_LIMIT_YEARLY = 0;
      #   TIMELINE_LIMIT_WEEKLY = 0;
      #   TIMELINE_LIMIT_MONTHLY = 0;
      #   TIMELINE_LIMIT_HOURLY = 0;
      #   TIMELINE_LIMIT_DAILY = 10;
      # };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
