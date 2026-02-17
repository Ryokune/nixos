{
  pkgs,
  lib,
  config,
  ...
}:

{
  # TODO: Move some of these into a generic cachix module
  environment.systemPackages = with pkgs; [ cachix ];

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://nix-substratum.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-substratum.cachix.org-1:vsxHvbD8g06FsfTplj4qYROX0BtM/I/HSpZNgpZHcRA="
    ];
  };

  # FIXME: May have to "glue" this to work with impermanence. We'll see.
  # Specific for my substratum packages repo. I'll probably move this somewhere else.
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
