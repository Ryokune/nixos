{ self, ... }:
{
  # FIXME: Its probably better to put this in a specific package instead
  # I think only lutris/gamemode/waydroid needs these? I completely forgot.
  systemd.settings.Manager = {
    DefaultLimitNOFILE = 524288;
  };

  security.pam.loginLimits = [
    {
      domain = "@users";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
}
