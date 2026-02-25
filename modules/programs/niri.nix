{ self, ... }:
{
  flake.nixosModules.niri =
    { ... }:
    {
      programs.niri.enable = true;
      programs.niri.useNautilus = false;
      xdg.portal.config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
      };

      # Would probably be better to be placed in a generic WM/DE Module in the future.
      services.gvfs.enable = true;
      services.udisks2.enable = true;
    };
}
