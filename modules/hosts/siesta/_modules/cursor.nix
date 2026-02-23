{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [ volantes-cursors ];
  environment.variables = {
    XCURSOR_THEME = "volantes_cursors";
  };
  services.displayManager.sddm = {
    settings = {
      Theme.CursorTheme = "volantes_cursors";
    };
  };
}
