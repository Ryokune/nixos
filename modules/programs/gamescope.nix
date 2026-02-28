{ self, ... }:
{
  flake.nixosModules.gamescope =
    { pkgs, ... }:
    {
      programs.gamescope = {
        enable = true;
        # capSysNice = true; # Recommended for performance
      };
      environment.systemPackages = with pkgs; [
        gamescope
        gamescope-wsi # Required for HDR support
      ];
    };
}
