{ self, ... }:
{
  security.rtkit.enable = true;
  security.protectKernelImage = true;

  security.polkit.enable = true;

  # FIXME: Probably better to move this onto programs/niri?
  services.gnome.gnome-keyring.enable = true; # secret service
}
