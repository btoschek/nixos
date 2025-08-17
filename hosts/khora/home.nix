{ config, inputs, pkgs, ... }:

{

  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
    ../../modules/home-manager/desktop/hyprland.nix
    ../../modules/home-manager/desktop/spotify.nix
    ../../modules/home-manager/terminal/zoxide.nix
    ../../modules/home-manager/terminal/git.nix
    ../../modules/home-manager/programs/media.nix
    ../../modules/home-manager/desktop/games.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "btoschek";
  home.homeDirectory = "/home/btoschek";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    pkgs.nerd-fonts.hack
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    shellAliases = {
      ls = "eza --icons -l";
      v = "nvim";
      vim = "nvim";
    }
    // (if config.programs.zoxide.enable then { cd = "z"; } else {});
    initContent = ''
      # Enable branches to be displayed in the prompt
      autoload -Uz vcs_info
      precmd () { vcs_info }

      zstyle ':vcs_info:git:*' formats '(%F{green} %b%f) '

      setopt PROMPT_SUBST
      PROMPT='%F{blue}%~%f ''${vcs_info_msg_0_}$ '

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }
    '';
  };

  programs.eza = {
    enable = true;
    git = true;
  };

  programs.gallery-dl.enable = true;

  programs.mangohud = {
    enable = true;
    settings = {
      toggle_hud = "F10";
      gpu_temp = true;
      cpu_temp = true;
      no_display = true;
    };
  };

  programs.eww = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yt-dlp.enable = true;

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.lazygit.enable = true;

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
  #  /etc/profiles/per-user/btoschek/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
