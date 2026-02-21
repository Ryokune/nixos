{ self, ... }:
{
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      # Fixes black screen.
      programs.steam.package = pkgs.steam.override {
        extraArgs = "-system-composer";
      };
    };
}
