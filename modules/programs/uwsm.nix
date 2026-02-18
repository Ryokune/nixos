{ self, lib, ... }:
{
  flake.nixosModules.uwsm =
    { config, pkgs, ... }:
    let
      uwsm = config.programs.uwsm;
    in
    {
      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          sway = lib.mkIf (config.programs.sway.enable) {
            prettyName = "Sway";
            comment = "Sway compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/sway";
          };
          niri = lib.mkIf (config.programs.niri.enable) {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri";
            extraArgs = [ "--session" ];
          };
        };
      };
      services.displayManager.sessionPackages =
        let
          mk_uwsm_desktop_entry =
            opts:
            (pkgs.writeTextFile {
              name = "${opts.name}-uwsm";
              text = ''
                [Desktop Entry]
                Name=${opts.prettyName} (UWSM)
                Comment=${opts.comment}
                Exec=${lib.getExe uwsm.package} start -F -- ${opts.binPath} ${lib.strings.escapeShellArgs opts.extraArgs}
                Type=Application
              '';
              destination = "/share/wayland-sessions/${opts.name}-uwsm.desktop";
              derivationArgs = {
                passthru.providedSessions = [ "${opts.name}-uwsm" ];
              };
            });
        in
        lib.mkAfter (
          lib.mapAttrsToList (
            name: value:
            mk_uwsm_desktop_entry {
              inherit name;
              inherit (value)
                prettyName
                comment
                binPath
                extraArgs
                ;
            }
          ) uwsm.waylandCompositors
        );
    };
}
