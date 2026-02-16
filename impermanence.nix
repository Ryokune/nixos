{ pkgs, ... }:

{

  boot.initrd.postResumeCommands = pkgs.lib.mkAfter ''
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

  # boot.initrd.postResumeCommands = pkgs.lib.mkAfter ''
  #   mkdir /btrfs_tmp
  #   mount /dev/mapper/cryptroot /btrfs_tmp
  #   if [[ -e /btrfs_tmp/@ ]]; then
  #     mkdir -p /btrfs_tmp/old_roots
  #     timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
  #     mv /btrfs_tmp/@ "/btrfs_tmp/old_roots/$timestamp"
  #   fi
  #
  #   delete_subvolume_recursively() {
  #     IFS=$'\n'
  #     for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #       delete_subvolume_recursively "/btrfs_tmp/$i"
  #     done
  #     btrfs subvolume delete "$1"
  #   }
  #
  #   for i in $(find /btrfs_tmp/old_roots -maxdepth 1 -mtime +30); do
  #     delete_subvolume_recursively "$i"
  #   done
  #
  #   btrfs subvolume create /btrfs_tmp/@
  #   umount /btrfs_tmp
  # '';

  # boot.initrd.postResumeCommands = pkgs.lib.mkAfter ''
  #   mkdir -p /mnt
  #   mount /dev/mapper/cryptroot /mnt
  # ''

  # fileSystems."./persist".neededForBoot = true;
  # fileSystems."./log".neededForBoot = true;

  fileSystems = {
    "/persist".neededForBoot = true;
    #"/home".neededForBoot = true;
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
    users.fish = {
      directories = [
        "Downloads"
        "Pictures"
        "Videos"
        "Documents"
        ".zen"
        # TODO: Only add needed impermanence for profiles, passwords, cookies, etc instead of the whole file.
        ".config/mozilla/firefox"
        ".mozilla/firefox" # if installed via home manager
        # ".config/vesktop"
        ".local/share/lutris"
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
        ".local/state/nix/profiles"
        ".local/share/waydroid"
        ".config/hayase/Service Worker"
        ".config/hayase/Local Storage"
        ".config/hayase/IndexedDB"
        ".config/sops"

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
        {
          file = ".config/hayase/Network Persistent State";
          method = "symlink";
        }
        {
          file = ".config/hayase/settings.json";
          method = "symlink";
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

        # ".config/niri/config.kdl"
      ];
    };
  };

}
