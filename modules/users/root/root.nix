{ inputs, ... }:
let
  name = "root";
in
{
  flake.nixosModules."users-${name}" =
    { pkgs, ... }:
    {
      users.users.${name} = {
        initialPassword = "nixos"; # fallback
        hashedPasswordFile = "/persist/etc/nixos/${name}PasswordFile";
      };
    };
}
