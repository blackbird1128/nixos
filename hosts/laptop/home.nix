{ config, pkgs, ... }:

{
  imports = [../../home-manager/common.nix];

  home.packages = with pkgs; [
    ani-cli
    aria2
    buku
    lutris
    winetricks
  ];
}
