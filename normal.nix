{ pkgs, ... }:
{
  specialisation = {
    normal.configuration = {
      environment.etc."specialisation".text = "normal";
      boot.kernelPackages = pkgs.linuxPackages;
    };
  };
}
