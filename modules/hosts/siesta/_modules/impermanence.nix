{ pkgs, inputs, ... }:

# FIXME: Move user impermanence in a dedicated module instead of here.
# TODO: Move the entire module into its own, dedicated module folder and make it reusable for multiple hosts and users. (eg: impermanence/...)
# TODO: Make home being impermanent as a toggleable config.
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  # This assumes that the host is using an encrypted BTRFS drive.
  # TODO: Make this work for ZFS, BTRFS, ext4, tmpfs root, etc.., and separate a lot of stuff.
  boot.initrd.systemd = {
    services.impermance-btrfs-root = {
      description = "BTRFS Impermanent Root Setup";
      # Specify dependencies explicitly
      unitConfig.DefaultDependencies = false;
      # The script needs to run to completion before this service is done
      serviceConfig = {
        Type = "oneshot";
        # NOTE: to be able to see errors in your script do this
        # StandardOutput = "journal+console";
        # StandardError = "journal+console";
      };
      # This service is required for boot to succeed
      requiredBy = [ "initrd.target" ];
      # Should complete before any file systems are mounted
      before = [ "sysroot.mount" ];

      # Wait until the root device is available
      # If you're altering a different device, specify its device unit explicitly.
      # see: systemd-escape(1)
      requires = [ "initrd-root-device.target" ];
      after = [
        "initrd-root-device.target"
        # Allow hibernation to resume before trying to alter any data
        "local-fs-pre.target"
      ];

      # The body of the script. Make your changes to data here
      script = ''
        mkdir -p /mnt
        mount /dev/mapper/cryptroot /mnt
        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/mnt/$i"
          done
          echo "Deleting subvolume $1"
          btrfs subvolume delete "$1"
        }
        delete_subvolume_recursively /mnt/@

        echo "Creating new root subvolume"
        btrfs subvolume create /mnt/@
        umount /mnt
      '';
    };
    extraBin = {
      # "mkfs.ext4" = "${pkgs.e2fsprogs}/bin/mkfs.ext4";
      "mkdir" = "${pkgs.coreutils}/bin/mkdir";
      "date" = "${pkgs.coreutils}/bin/date";
      "stat" = "${pkgs.coreutils}/bin/stat";
      "mv" = "${pkgs.coreutils}/bin/mv";
      "find" = "${pkgs.findutils}/bin/find";
      "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
      # mount & umount already exist
    }; # NOTE: path = [...]; doesnt work for initrd, use full paths in your script or extraBin
  };
  fileSystems = {
    "/persist" = {
      neededForBoot = true;
    };
  };
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/snapper"
      "/var/lib/bluetooth"
      "/var/lib/networkmanager"
      "/var/lib/systemd/timers"
      "/etc/ssh"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/voidbackup"
      "/var/lib/waydroid"
      "/var/lib/tailscale"
      {
        directory = "/var/lib/cachix-w";
        user = "root";
        group = "root";
        mode = "0700";
      }
    ];
    files = [
      "/etc/adjtime"
      "/etc/machine-id"
    ];

    # TODO/FIXME: Move this in the users specific users/fish.nix, if impermanence is enabled.
    # TODO: Add program specific directories to their own modules. eg: impermanence/programs/vesktop for more sane and reusable defaults.
    users.fish = {
      directories = [
        "Downloads"
        "Pictures"
        "Videos"
        "Documents"
        ".zen"
        ".local/state/wireplumber"
        # TODO: Only add needed impermanence for profiles, passwords, cookies, etc instead of the whole file.
        ".config/mozilla/firefox"
        ".mozilla/firefox" # if installed via home manager
        ".config/vesktop"
        ".local/share/lutris"
        ".config/Moonlight Game Streaming Project"
        # ".config/lutris"
        ".cache/lutris"
        # ".config/waybar"
        ".local/state/nvim"
        ".config/home-manager"
        ".local/share/home-manager"
        ".local/share/nvim"
        ".local/state/nix"
        ".local/share/nix"
        ".wine"
        ".steam"
        ".local/share/Steam"
        ".local/share/umu"
        "Games"
        #".local/state/nix/profiles"
        ".local/share/waydroid"
        ".config/Ryujinx"
        ".config/hayase/Service Worker"
        ".config/hayase/Local Storage"
        ".config/hayase/IndexedDB"
        ".config/sops"
        ".config/nvf"
        ".config/OpenTabletDriver"
        "Anime"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".nixops";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ];
      files = [
        {
          file = ".config/htop/htoprc";
          method = "symlink";
        }
        # {
        #   file = ".config/hayase/Network Persistent State";
        #   method = "symlink";
        # }
        {
          file = ".config/hayase/settings.json";
          #method = "symlink";
        }
        {
          file = ".config/hayase/Cookies";
          # method = "symlink";
        }
        {
          file = ".config/hayase/Cookies-journal";
          # method = "symlink";
        }
        {
          file = ".config/hayase/Trust Tokens";
          # method = "symlink";
        }
        {
          file = ".config/hayase/Trust Tokens-journal";
          # method = "symlink";
        }
        {
          file = ".config/hayase/TransportSecurity";
          # method = "symlink";
        }
        {
          file = ".config/hayase/Preferences";
          # method = "symlink";
        }
        ".config/kritarc"

        # ".config/niri/config.kdl"
      ];
    };
  };

}
