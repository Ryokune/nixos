{ self, inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
  ];
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/ata-CT1000MX500SSD1_2132E5BE3ADF";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };
                # "@home" = { mountOptions = [ "compress=zstd" ]; };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };
                "@swap" = {
                  mountpoint = "/swap";
                  mountOptions = [
                    "noatime"
                    "nodatacow"
                    "nodatasum"
                    "discard=async"
                  ];
                  swap = {
                    swapfile = {
                      size = "20G";
                      priority = 0;
                    };
                  };
                };
                "@varlog" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "nodatacow"
                    "ssd"
                    "discard=async"
                  ];
                };
                "@vartmp" = {
                  mountpoint = "/var/tmp";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };

                # TODO: Move persistance in a separate, toggleable module
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };
                # "@snapshots-home" = { mountpoint = "/home/.snapshots"; mountOptions = [ "compress=zstd" "noatime" ]; };
                "@snapshots-persist" = {
                  mountpoint = "/persist/.snapshots";
                  mountOptions = [
                    "discard=async"
                    "compress=zstd"
                    "noatime"
                    "ssd"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
