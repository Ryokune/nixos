{ pkgs, inputs, ... }:
{
  imports = [
    inputs.preservation.nixosModules.default
  ];
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
    "/var/log" = {
      neededForBoot = true;
    };
  };

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persist/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist"
    ];
  };
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }

        "/etc/adjtime"
      ];
      directories = [
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
      users.fish = {
        commonMountOptions = [
          "x-gvfs-hide"
          "x-gdu.hide"
        ];
        directories = [
          "Downloads"
          "Pictures"
          "Videos"
          "Documents"
          ".zen"
          ".local/state/wireplumber"
          # TODO: Only add needed impermanence for profiles, passwords, cookies, etc instead of the whole file.
          ".config/mozilla/firefox"
          #".mozilla/firefox" # if using legacy folder path.
          ".config/vesktop"
          ".local/share/lutris"
          ".config/Moonlight Game Streaming Project"
          # ".config/lutris"
          ".cache/lutris"
          ".var/app"
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
          ".local/share/dynamicwidget"
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
            how = "symlink";
          }
          # {
          #   file = ".config/hayase/Network Persistent State";
          #   method = "symlink";
          # }
          ".config/hayase/settings.json"
          ".config/hayase/Cookies"
          ".config/hayase/Cookies-journal"
          ".config/hayase/Trust Tokens"
          ".config/hayase/Trust Tokens-journal"
          ".config/hayase/TransportSecurity"
          ".config/hayase/Preferences"
          ".config/kritarc"
        ];
      };
    };
  };
}
