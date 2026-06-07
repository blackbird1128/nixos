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
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
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

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 360;
        height = 140;
        origin = "top-right";
        offset = "16x40";
        scale = 0;
        notification_limit = 5;

        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 160;
        progress_bar_max_width = 320;

        indicate_hidden = true;
        transparency = 4;
        separator_height = 1;
        padding = 12;
        horizontal_padding = 14;
        text_icon_padding = 12;
        frame_width = 2;
        gap_size = 8;
        corner_radius = 8;

        sort = true;
        idle_threshold = 120;
        font = "Sans 10";
        line_height = 2;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = false;

        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 48;

        sticky_history = true;
        history_length = 20;

        browser = "firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
      };
      urgency_low = {
        background = "#282828";
        foreground = "#a89984";
        frame_color = "#504945";
        highlight = "#83a598";
        timeout = 4;
      };
      urgency_normal = {
        background = "#32302f";
        foreground = "#ebdbb2";
        frame_color = "#83a598";
        highlight = "#83a598";
        timeout = 7;
      };
      urgency_critical = {
        background = "#3c3836";
        foreground = "#fbf1c7";
        frame_color = "#cc241d";
        highlight = "#fb4934";
        timeout = 0;
      };
    };
  };
}
