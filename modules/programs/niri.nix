{ self, ... }:
{
  flake.nixosModules.niri =
    { ... }:
    {
      programs.niri.enable = true;
      xdg.portal.config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
      };
    };
}
