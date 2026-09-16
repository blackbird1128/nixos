{ config, lib, pkgs, ... }:

{
  imports = [../../home-manager/common.nix];

  home.packages = with pkgs; [
    ani-cli
    buku
    lutris
    winetricks
  ];

  services.picom.settings = {
    use-damage = lib.mkForce true;
    unredir-if-possible = lib.mkForce true;
  };
}
