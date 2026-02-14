{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    # (self: super: {
    #   myCachyosKernel = super.linuxPackages_cachyos.override {
    #     structuredExtraConfig = with super.lib.kernel; {
    #       MEMCG = yes;
    #       MEMCG_SWAP = yes;
    #       # optionally also:
    #       CPUSETS = yes;
    #       BLK_CGROUP = yes;
    #     };
    #   };
    # })
  ];
  # Binary cache
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  specialisation = {
    cachyos.configuration = {
      environment.etc."specialisation".text = "cachyos";
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

      # services.scx.enable = true;
      services.scx.scheduler = "scx_lavd";
      programs.gamemode.enable = false;
      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
  };
}
