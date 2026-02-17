{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ cachix ];

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://nix-substratum.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-substratum.cachix.org-1:vsxHvbD8g06FsfTplj4qYROX0BtM/I/HSpZNgpZHcRA="
    ];
  };
}
