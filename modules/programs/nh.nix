{ self, ... }:
{
  flake.nixosModules.nh =
    { ... }:
    {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep 3 --keep-since 7d";
      };
      environment.sessionVariables = {
        NH_OS_FLAKE = "/etc/nixos";
      };
    };
}
