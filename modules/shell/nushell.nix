{den, ...}: {
  den.aspects.base.homeManager = {
    programs.nushell = {
      # NOTE: Doesn't need to be set here, will be set by user config instead
      #enable = true;

      configFile = {
        text = ''
          $env.EDITOR = "nvim";
          $env.config.show_banner = false

          def create_left_prompt [] {
            let path_segment = ($env.PWD | str replace $nu.home-dir '~')
            let is_git_repo = (git rev-parse --is-inside-work-tree e> /dev/null | str contains 'true')
            let git_br = if $is_git_repo { git branch --show-current | str trim }

            let git_info = if $is_git_repo {
              $"(ansi reset) \((ansi green) ($git_br)(ansi reset)\)"
            } else {
              ""
            }

            [
              (ansi blue)
              $path_segment
              $git_info
            ] | str join ""
          }

          $env.PROMPT_COMMAND = { || create_left_prompt }
          $env.PROMPT_INDICATOR = " "
        '';
      };
      settings = {
        buffer_editor = "nvim";
      };
      shellAliases = {
        v = "nvim";
        vim = "nvim";
        rebuild-switch = "nixos-rebuild switch --flake ~/nixos --sudo"; # NOTE: Previously --use-remote-sudo
      };
    };
  };
}
