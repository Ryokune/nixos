{ inputs, ... }:
let
  name = "root";
in
{
  flake.nixosModules."users-${name}" =
    { pkgs, ... }:
    {
      users.users.${name} = {
        
      };
    };
}
