{ self, ... }:
{
  flake.nixosModules.otd =
    { ... }:
    {
      hardware.opentabletdriver.enable = true;
      hardware.uinput.enable = true;
      boot.kernelModules = [ "uinput" ];
    };
}
