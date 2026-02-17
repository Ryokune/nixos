{ self, ... }:
{
  flake.nixosModules.zsh =
    { ... }:
    {
      programs.zsh.enable = true;
    };
}
