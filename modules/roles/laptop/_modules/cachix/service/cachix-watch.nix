{
  pkgs,
  lib,
  config,
  ...
}:

{
  # FIXME: May have to "glue" this to work with impermanence. We'll see.
  # Specific for my substratum packages repo. I'll probably move this somewhere else
  # Probably will be within substratums flake.nix, but eh. Thats for the future
  systemd.services.cachix-watch = {
    description = "Cachix Watch Store Service";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      KillMode = "process";
      Restart = "on-failure";
      RestartSec = 5;

      LoadCredential = [
        "token:/var/lib/cachix-w/auth_token"
        "key:/var/lib/cachix-w/signing_key"
      ];

      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;

      ReadOnlyPaths = [ "/var/lib/cachix-w" ];
    };

    script = ''
      CACHIX_AUTH_TOKEN=$(cat "$CREDENTIALS_DIRECTORY/token") \
      exec ${pkgs.cachix}/bin/cachix watch-store nix-substratum
    '';
  };
}
