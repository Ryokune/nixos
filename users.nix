{ pkgs, ... }:

{
  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = "$6$UyGHXu6UvorYDRV0$yTgjq1rfU.pgdbPnF71drWeacH1w1atlf8hCdzTdnVe1LJwuVqay74zIibgBFUF.exMQOLDPeoG1kqzBsUYth0";
  };
  users.users.fish = {
    isNormalUser = true;
    shell = pkgs.zsh;
    hashedPassword = "$6$XBqUJTayyp7MGSyq$rZZzx.mCx8yjtIb9Pb2LSLDrshOnj4WiyV8OReLRh0.iiETQxpV2iAnAqCMM5FazlIewWKGt0n20G.P0RQo0q.";
    extraGroups = [
      "wheel"
      "networkmanager"
      "users"
      "input"
      "audio"
      "video"
      "gamemode"
    ];
  };
}
