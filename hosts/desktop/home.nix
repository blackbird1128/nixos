{ config, inputs, lib, pkgs, ... }:

let
  stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [../../home-manager/common.nix];

  home.packages = with pkgs; [
    ani-cli
    buku
    stable.lutris
    stable.winetricks
    vulkan-tools
  ];

  services.picom.settings = {
    use-damage = lib.mkForce true;
    unredir-if-possible = lib.mkForce true;
  };
}
