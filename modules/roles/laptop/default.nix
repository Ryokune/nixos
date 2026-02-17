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
        self.nixosModules.niri
        self.nixosModules.steam
        self.nixosModules.zsh
        (inputs.import-tree ./_modules)
      ];

      zramSwap = {
        enable = true;
        priority = 100;
      };

      environment.sessionVariables = {
        # QT_QPA_PLATFORMTHEME = "qt6ct";
        HOSTNAME = config.networking.hostName;
      };

      hardware.enableRedistributableFirmware = true;
    };
}
