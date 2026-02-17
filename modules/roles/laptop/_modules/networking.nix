{ self, pkgs, ... }:
{
  networking = {
    firewall.enable = true;
    nftables.enable = true;
    networkmanager = {
      enable = true;
      settings = {
        connectivity = {
          enabled = true;
          uri = "http://connectivity-check.ubuntu.com/";
          interval = 30;
        };
      };
    };
  };

  # TODO: Move into its own WAYBAR package.nix, possibly make it optional too.
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "20-waybar-nm" ''
        # Called when interface changes
        if [ "$2" = "connectivity-change" ]; then
            ${pkgs.procps}/bin/pkill -RTMIN+3 waybar 2>/dev/null
        fi
        exit 0
      '';
      type = "basic";
    }
  ];
}
