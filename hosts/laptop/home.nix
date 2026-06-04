{ config, pkgs, ... }:

{
  imports = [../../home-manager/common.nix];

  home.packages = with pkgs; [
    ani-cli
    aria2
    buku
    codex
    lutris
    wineWow64Packages.stable
    winetricks
    zotero
  ];
}
