{ self, ... }:
{
  flake.nixosModules.gamemode =
    { ... }:
    {
      programs.gamemode.enable = true;
    };
}
