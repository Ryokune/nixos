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
        initialPassword = "nixos"; # fallback
        hashedPasswordFile = "/persist/etc/nixos/${name}PasswordFile";
        extraGroups = [
          "wheel"
          "networkmanager"
          "users"
          "input"
          "audio"
          "video"
          "render"
          "gamemode"
        ];
      };
    };

}
