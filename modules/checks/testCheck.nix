{ ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      self',
      ...
    }:
    {
      checks = {
        math = pkgs.runCommand "math-test" { } ''
          test $(( 1 + 1 )) -eq  3
          touch $out
        '';
      };
    };
}
