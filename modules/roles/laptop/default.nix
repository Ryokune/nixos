{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.laptop =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.hayase
        self.nixosModules.dconf
        self.nixosModules.gamemode
        self.nixosModules.light
        self.nixosModules.nh
        self.nixosModules.niri
        self.nixosModules.steam
        self.nixosModules.zsh
        self.nixosModules.waydroid
        self.nixosModules.uwsm
        self.nixosModules.gamescope
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
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        intel-ocl
      ];
    };
}
