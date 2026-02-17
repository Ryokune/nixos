{ inputs, ... }:
let
  name = "fish";
in
{
  flake.nixosModules."users-${name}" =
    { pkgs, ... }:
    {
      users.users.${name} = {
        isNormalUser = true;
        shell = pkgs.zsh;
      };
    };
}
