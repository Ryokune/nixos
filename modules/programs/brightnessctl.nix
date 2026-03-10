{ self, ... }:
{
  flake.nixosModules.brightness =
    { ... }:
    {
      programs.brightnessctl.enable = true;
    };
}
