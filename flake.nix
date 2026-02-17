{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };

    hm-standalone-auto = {
      url = "path:/home/fish/Documents/projects/nix-flakes/hm_impermanence_standalone";
    };

    #nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      impermanence,
      hm-standalone-auto,
      ...
    }:
    {
      nixosConfigurations.siesta = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; }
          disko.nixosModules.disko

          impermanence.nixosModules.impermanence
          hm-standalone-auto.nixosModules.hm-standalone-auto

          ./disko-config.nix
          ./configuration.nix
          ./specialisations/lts.nix
          ./services/waydroid.nix

          # home-manager.nixosModules.home-manager
          #
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.users = nixpkgs.lib.mapAttrs (_: mods: { imports = mods; }) hmUsers;
          # }
        ];
      };

      # homeConfigurations = nixpkgs.lib.mapAttrs (
      #   username: mods:
      #   home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = mods;
      #   }
      # ) hmUsers;

      # homeConfigurations.fish = home-manager.lib.homeManagerConfiguration {
      #   pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #   modules = hmModules.fish;
      # };
    };
}
