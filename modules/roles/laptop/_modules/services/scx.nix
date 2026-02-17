{ self, lib, ... }:
{
  services.scx.enable = lib.mkDefault true;
  services.scx.scheduler = lib.mkDefault "scx_bpfland";
}
