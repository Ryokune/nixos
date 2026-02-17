{ self, ... }:
{
  nix.settings.use-xdg-base-directories = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "root" ];
    auto-optimise-store = true;
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
}
