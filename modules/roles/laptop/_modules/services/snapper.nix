{ self, ... }:
{
  # TODO: Move this in a generic impermanence module, with a snapper.enable config.
  services.snapper = {
    persistentTimer = true;
    snapshotInterval = "daily";
    configs = {
      # Snapshots for your persistent system data
      persist = {
        SUBVOLUME = "/persist";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_YEARLY = 0;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_HOURLY = 0;
        TIMELINE_LIMIT_DAILY = 10;
      };
    };
  };
}
