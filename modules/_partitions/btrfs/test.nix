{ self, ... }:
{
  flake.diskoConfigurations = {
    btrfs = {
      disko.devices = {

      };
    };
  };
}
