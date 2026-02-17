{ inputs, lib, ... }:

{
  flake.users =
    let
      userModules = lib.filterAttrs (n: v: lib.hasPrefix "users-" n) inputs.self.nixosModules;
    in
    lib.mapAttrs' (n: v: lib.nameValuePair (lib.removePrefix "users-" n) v) userModules;
}
