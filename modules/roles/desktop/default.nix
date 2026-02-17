{ self, inputs, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, environment, ... }:
    {
      imports = [
        self.nixosModules.dconf
        self.nixosModules.gamemode
        self.nixosModules.light
        self.nixosModules.steam
        self.nixosModules.zsh
        (inputs.import-tree ./_modules)
      ];
    };
}
