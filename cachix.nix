{
  pkgs,
  lib,
  config,
  ...
}:

{
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

  systemd.services.cachix-watch = {
    description = "Cachix Watch Store Service";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      KillMode = "process";
      Restart = "on-failure"; # Crucial for long-running services
      RestartSec = 5;

      LoadCredential = [
        "token:/var/lib/cachix-w/auth_token"
        "key:/var/lib/cachix-w/signing_key"
      ];

      # Hardening (Keep these inside serviceConfig!)
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      # Ensure the service can't write to its own home, only read
      ReadOnlyPaths = [ "/var/lib/cachix-w" ];
    };

    script = ''
      CACHIX_AUTH_TOKEN=$(cat "$CREDENTIALS_DIRECTORY/token") \
      exec ${pkgs.cachix}/bin/cachix watch-store nix-substratum
    '';
  };
}
