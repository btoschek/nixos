{ config, ... }:

{
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
    '' + (if config.programs.direnv.enable then "eval \"$(direnv hook zsh)\"" else "");
  };
}
