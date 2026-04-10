{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ inputs.home-manager.nixosModules.default ];

    # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  environment.pathsToLink = ["/libexec" ];
  
  nix.settings.allowed-users = [ "@wheel" ];
  security.sudo.execWheelOnly = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 53 ];
    allowedUDPPorts = [ 53 ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1;    # enable port forwarding
  };
  
  networking.firewall.extraCommands = ''
    # Generic port redirects for container services.
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8000
    iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-port 5300
    iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5300
  '';
  networking.firewall.extraStopCommands = ''
    iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8000
    iptables -t nat -D PREROUTING -p tcp --dport 53 -j REDIRECT --to-port 5300
    iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5300
  '';
  
  # services.dnscrypt-proxy = {
  #   enable = true;
  #   settings = {
  #     server_names = [  "plan9dns-nj.ipv6" "a-and-a" "doh.ffmuc.net"];
  #     listen_addresses = [ "127.0.0.1:53" ];
  #     require_dnssec = true;
  #     # Optional: force DoH only
  #     doh_servers = true;
  #   };
  # };

  # networking.nameservers = [ "127.0.0.1" ];
  # services.resolved.enable = false; # Avoid conflicts
  
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alexj = {
    isNormalUser = true;
    description = "alexj";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      eza mcfly starship emacs firefox kitty feh bluetuith opam tealdeer dust gh
      texliveFull tree-sitter];
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      hinting.enable = true;
      hinting.autohint = false;
      hinting.style = "slight";
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.iosevka
      jetbrains-mono
    ];
  };
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = lib.mkDefault true;
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
        AutoConnect = true;
      };
    };
  };

  services.blueman.enable = lib.mkDefault true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    alsa-utils
    brightnessctl
    cairo
    emacs.pkgs.jinx
    enchant
    fontconfig
    freetype
    gcc
    gnumake
    gvfs
    harfbuzz
    hunspell
    hunspellDicts.en-us
    hunspellDicts.fr-moderne
    imagemagick
    jq
    killall
    libnotify
    libxft
    lm_sensors
    mons
    ntfs3g
    networkmanagerapplet
    p7zip
    pavucontrol
    perl
    playerctl
    pulseaudio
    python3
    rofi
    slop
    stow
    sysstat
    wget
    xclip
    xrandr
    zip
    unzip
    fd
    zsh
    file-roller
    git-extras
    rename
    mpv
    graphviz
    ninja
  ];

  programs.thunar  = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.dbus.enable = true;

  programs.dconf.enable = true;

  services.hardware.openrgb.enable = true;
  services.xserver = {
    enable = true;
    dpi = 104;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = { lightdm.enable = true;};

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      extraPackages = with pkgs; [dmenu i3status i3blocks i3lock];
    };

 };

  nixpkgs.config.pulseaudio = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  services.displayManager.defaultSession = "none+i3";

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

}
