{ self, ... }:
{
  flake.nixosModules.hayase =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      app = pkgs.substratum.hayase;

      hayaseProfile = pkgs.writeText "hayase-firejail.profile" ''
        include disable-common.inc
        include disable-exec.inc
        #include disable-programs.inc
        ipc-namespace
        blacklist /voidbackup
        blacklist /persist
        whitelist ~/.config/hayase
        whitelist ~/.cache/hayase
        whitelist ~/Anime/Hayase
        private-dev
        private-tmp
        private-etc hosts,resolv.conf,ssl,ca-certificates
        seccomp !mount,!umount2,!pivot_root,!chroot,!membarrier

        noinput
        nogroups
        nonewprivs
        noroot
        caps.drop all

        netfilter
        protocol unix,inet,inet6,netlink

        rlimit-nofile 8192
        rlimit-nproc 512
      '';
    in
    {
      programs.firejail = {
        enable = true;
        wrappedBinaries = {
          hayase = {
            executable = lib.getExe app;
            profile = hayaseProfile;
          };
        };
      };

      environment.systemPackages = [ app ];

      security.allowUserNamespaces = true;
    };
}
