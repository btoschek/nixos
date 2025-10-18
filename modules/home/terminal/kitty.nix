{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.kitty;
in
{
  options = {
    userSettings.kitty = {
      enable = lib.mkEnableOption "Enable kitty";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
        size = 12;
      };

      shellIntegration = {
        mode = "no-cursor";
        enableZshIntegration = config.programs.zsh.enable;
      };

      keybindings = {
        # Clipboard
        "super+v" = "paste_from_clipboard";
        "ctrl+shift+s" = "paste_from_selection";
        "super+c" = "copy_to_clipboard";
        "shift+insert" = "paste_from_selection";

        # Scrolling
        "ctrl+shift+k" = "scroll_line_up";
        "ctrl+shift+j" = "scroll_line_down";
        "ctrl+shift+page_up" = "scroll_page_up";
        "ctrl+shift+page_down" = "scroll_page_down";
        "ctrl+shift+home" = "scroll_home";
        "ctrl+shift+end" = "scroll_end";
        "ctrl+shift+h" = "show_scrollback";

        # Miscellaneous
        "ctrl+shift+up" = "increase_font_size";
        "ctrl+shift+down" = "decrease_font_size";
        "ctrl+shift+backspace" = "restore_font_size";
      };

      settings = {
        foreground = "#a9b1d6";
        background = "#1a1b26";

        selection_foreground = "none";
        selection_background = "#28344a";

        cursor_shape = "beam";

        cursor_blink_interval = 0.5;
        cursor_stop_blinking_after = 15.0;

        scrollback_lines = 2000;
        scrollback_pager = "less +G -R";
        wheel_scroll_multiplier = 5.0;

        click_intreval = 0.5;
        select_by_word_characters = ":@-./_~?&=%+#";
        mouse_hide_wait = 0.0;
        enabled_layouts = "*";

        remember_window_size = false;
        initial_window_width = 640;
        initial_window_height = 400;

        repaint_delay = 10;
        input_delay = 3;

        visual_bell_duration = 0.0;
        enable_audio_bell = false;

        open_url_modifiers = "ctrl+shift";
        open_url_with = "default";

        term = "xterm-kitty";

        window_border_width = 0;
        window_margin_width = 15;

        active_border_color = "#3d59a1";
        inactive_border_color = "#101014";

        active_tab_foreground = "#000";
        active_tab_background = "#eee";
        inactive_tab_foreground = "#444";
        inactive_tab_background = "#999";

        # black
        color0 = "#414868";
        color8 = "#414868";

        # red
        color1 = "#f7768e";
        color9 = "#f7768e";

        # green
        color2 = "#73daca";
        color10 = "#73daca";

        # yellow
        color3 = "#e0af68";
        color11 = "#e0af68";

        # blue
        color4 = "#7aa2f7";
        color12 = "#7aa2f7";

        # magenta
        color5 = "#bb9af7";
        color13 = "#bb9af7";

        # cyan
        color6 = "#7dcfff";
        color14 = "#7dcfff";

        # white
        color7 = "#c0caf5";
        color15 = "#c0caf5";

        cursor = "#c0caf5";

        hide_window_decorations = "titlebar-only";
        macos_option_as_alt = false;
        macos_titlebar_color = "background";

        # Cursor trail
        cursor_trail = 3;
        cursor_trail_decay = "0.01 0.05";

        confirm_os_window_close = 0;
      };
    };
  };
}
