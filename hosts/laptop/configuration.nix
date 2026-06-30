# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/common.nix
    ];

    # hardware.facter.reportPath = ./facter.json;

  boot.kernelParams = [
    "mem_sleep_default=deep"
    "amd_pstate=active"
    "button.lid_init_state=method"
  ];


  networking.hostName = "laptop"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alexj = {
    isNormalUser = true;
    description = "alexj";
    extraGroups = [ "networkmanager" "wheel" ];
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
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi acpid xss-lock
  ];

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      HandleLidSwitchDocked = "suspend-then-hibernate";
      IdleAction = "suspend-then-hibernate";
      IdleActionSec = "5min";
    };
  };
  # systemd.sleep.extraConfig = ''
  #   HibernateDelaySec=60min
  # '';
  
  services.acpid.enable = true;
  powerManagement.enable = true;  
  services.power-profiles-daemon.enable = false;
	  services.tlp = {
	    enable = true;
	    settings = {
	      CPU_DRIVER_OPMODE_ON_AC = "active";
	      CPU_DRIVER_OPMODE_ON_BAT = "active";
	      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
	      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
	      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
	      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
	      CPU_BOOST_ON_AC = 1;
	      CPU_BOOST_ON_BAT = 0;
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT1 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT1 = 80;  # 80 and above it stops charging
    };
  };

  
  services.upower.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
