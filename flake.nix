{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };

    # TODO: Move into its own gitub repo
    hm-standalone-auto = {
      url = "path:/home/fish/Documents/projects/nix-flakes/hm_impermanence_standalone";
    };
    substratum = {
      url = "git+file:///home/fish/Documents/projects/nix-flakes/substratum";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      imports = [
        (inputs.import-tree ./modules)
      ];
      debug = true;
    };
}
