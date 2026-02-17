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
        inputs.substratum.nixosModules.default
        {
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

      hardware.enableRedistributableFirmware = true;
    };
}
