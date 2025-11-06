# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/common.nix
      inputs.home-manager.nixosModules.default
    ];

  environment.pathsToLink = ["/libexec" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  programs.zsh.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alexj = {
    isNormalUser = true;
    description = "alexj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [eza mcfly starship emacs firefox kitty feh bluetuith opam gh tealdeer ani-cli];
    shell = pkgs.zsh;
  };

  home-manager = {

    extraSpecialArgs = { inherit inputs;};
    users = {
      "alexj" = import ./home.nix;
    };

  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; 
  hardware.nvidia.open = false;  #

  fonts = {
    fontconfig = {
      antialias = true;
      hinting.enable = true;
      hinting.autohint = false;
      hinting.style = "slight";
      subpixel.rgba = "none";
      subpixel.lcdfilter = "light";
    };
  };
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];
  
  services.xserver = {

    xrandrHeads = [
      {
        output = "HDMI-0";
        primary = true;
      }
      {
        output = "DVI-D-1";
      }
    ];


  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
