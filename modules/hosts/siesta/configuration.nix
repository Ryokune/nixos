{ inputs, self, ... }:
{
  flake.nixosConfigurations.siesta = inputs.nixpkgs.lib.nixosSystem {
    # Unsure if this is properly needed here. But its here due to ./_modules/disko.nix
    # I'll probably move disko.nix as a flake.nixosModules instead in the future.
    # Or some sort of "partitioning scheme".
    specialArgs = { inherit inputs; };
    modules = [
      (inputs.import-tree ./_modules)
      self.users.fish
      self.nixosModules.laptop
      inputs.rehomify.nixosModules.rehomify
      {
        # Host specific declarations
        # TODO: Move this in the impermanence module.
        rehomify.enable = true;
        security.sudo.extraConfig = "Defaults lecture=never";
        services.journald.storage = "persistent";
        users.mutableUsers = false;
        networking.hostName = "siesta";
        time.timeZone = "Asia/Manila";
        i18n.defaultLocale = "en_US.UTF-8";
        system.stateVersion = "26.05";
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      }
    ];
  };
}
