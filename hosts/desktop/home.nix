{ config, pkgs, ... }:

{
  imports = [../../home-manager/common.nix];

  home.packages = with pkgs; [
    ani-cli
    buku
    codex
    lutris
    winetricks
  ];
}
