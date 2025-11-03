{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alexj";
  home.homeDirectory = "/home/alexj";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  xsession.enable = true;
  xsession.windowManager.command = "i3";
  

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    pkgs.st
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alexj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "blackbird1128";
      user.email = "37084688+blackbird1128@users.noreply.github.com";
      core.editor = "emacs";
      init.defaultBranch = "main";

    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };


  programs.fzf.enable = true;
  
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;

  };
  programs.htop.enable = true;
  programs.ripgrep.enable = true;

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    settings = {
      glx-no-stencil = true;
      glx-copy-from-front = false;
      use-damage = true;
      # Optional, can improve font rendering on some GPUs:
      unredir-if-possible = false;
    };
    extraArgs = [ "--experimental-backends" ];
  };

  
  services.dunst = {
    enable = true;

    # optional
    settings = {
      global = {
        font = "Sans 10";
        frame_width = 2;
        separator_height = 2;
      };
      urgency_low = {
        background = "#222222";
        foreground = "#888888";
      };
      urgency_normal = {
        background = "#285577";
        foreground = "#ffffff";
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
      };
    };
  };
}
