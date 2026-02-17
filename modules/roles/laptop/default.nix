{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.nixosModules.laptop =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.dconf
        self.nixosModules.gamemode
        self.nixosModules.light
        self.nixosModules.nh
        self.nixosModules.niri
        self.nixosModules.steam
        self.nixosModules.zsh
        self.nixosModules.waydroid
        self.nixosModules.uwsm
        inputs.substratum.nixosModules.default
        {
          services.waydroid.enable = true;
          nixpkgs.overlays = [
            inputs.substratum.overlays.default
          ];
        }
        (inputs.import-tree ./_modules)
      ];

      zramSwap = {
        enable = true;
        priority = 100;
      };

      services.fwupd.enable = true;
      hardware.enableRedistributableFirmware = true;
    };
}
