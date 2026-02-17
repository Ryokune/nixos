{ inputs, self, ... }:
{
  flake.nixosConfigurations.siesta = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (inputs.import-tree ./_modules)
      self.users.fish
      self.nixosModules.laptop
      {
        # Host specific declarations
        networking.hostName = "siesta";
        time.timeZone = "Asia/Manila";
        i18n.defaultLocale = "en_US.UTF-8";
        system.stateVersion = "26.05";
      }
    ];
  };
}
