{ pkgs, ... }:
{
  specialisation = {
    lts.configuration = {
      environment.etc."specialisation".text = "lts";
      boot.kernelPackages = pkgs.linuxPackages;
    };
  };
}
