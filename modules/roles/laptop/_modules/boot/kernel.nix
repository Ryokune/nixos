{ pkgs, ... }:
{

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Favor RAM over swap
    "vm.vfs_cache_pressure" = 50; # Keep inode/dentry caches longer
  };
  boot.kernelModules = [ "ntsync" ];
  boot.kernelParams = [
    "psi=1"
    "pcie_aspm=off"
    "intel_iommu=igfx_off"
  ];

  boot.tmp.cleanOnBoot = true;
}
