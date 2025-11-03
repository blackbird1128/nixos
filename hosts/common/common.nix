{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
    ];

  environment.pathsToLink = ["/libexec" ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  
  # Enable networking
  networking.networkmanager.enable = true;


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

  programs.zsh.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alexj = {
    isNormalUser = true;
    description = "alexj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [eza mcfly starship emacs firefox kitty feh bluetuith opam tealdeer
#    (texlive.withPackages (ps: with ps; [
#      scheme-medium
#      wrapfig
#      capt-of
#      preprint
#      titling
#      enumitem
#      hyperref
];
#    ]))];
  };



  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
    gcc
    wget
    xclip
    stow
    zsh
    rofi
    direnv
    enchant
    hunspell
    hunspellDicts.en-us
    hunspellDicts.fr-moderne
    libnotify
    playerctl
    killall
    perl
    gvfs
    ntfs3g
    file-roller
    p7zip
    gnumake
    python3
    acpi
    pulseaudio
    brightnessctl
    sysstat
    imagemagick
    slop
    emacs.pkgs.jinx
    xrandr
    mons
    fontconfig
    freetype
    cairo
    libxft
    harfbuzz
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

}
