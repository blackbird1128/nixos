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
  home.stateVersion = "26.05"; # Please read the comment before changing.

  xsession.enable = true;
  xsession.windowManager.command = "i3";
  

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bluetuith
    dust
    emacs
    eza
    feh
    firefox
    gh
    kitty
    mcfly
    opam
    starship
    tealdeer
    texliveFull
    tree-sitter
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
      credential = {
        helper = "store --file ~/.git-credentials";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
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
      glx-copy-from-front = false;
      use-damage = false;
      # Optional, can improve font rendering on some GPUs:
      xrender-sync-fence = true;
      unredir-if-possible = false;
    };
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
