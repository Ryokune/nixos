{ self, ... }:
{
  flake.nixosModules.light =
    { ... }:
    {
      programs.light.enable = true;
    };
}
