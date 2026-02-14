{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.waydroid;
in
{
  options.services.waydroid = {
    enable = mkEnableOption "waydroid-container Service";
  };
  config = mkIf cfg.enable {

    networking.firewall.trustedInterfaces = [ "waydroid0" ];

    virtualisation.waydroid = {
      enable = true;
      package = if config.networking.nftables.enable then pkgs.waydroid-nftables else pkgs.waydroid;
    };

    # Improves the existing service
    systemd.services.waydroid-container = {
      serviceConfig = {
        # Enable cgroups v2 delegation (fixes "Read-only file system" errors)
        Delegate = true;
        CPUAccounting = true;
        MemoryAccounting = true;
        TasksAccounting = true;
      };
    };
  };
}
