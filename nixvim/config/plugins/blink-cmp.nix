{
  config,
  lib,
  ...
}: {
  plugins.blink-cmp-git.enable = true;

  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;
    settings = {
      completion = {
        documentation = {
          auto_show = true;
        };

        menu = {
          border = "rounded";
        };

        ghost_text.enabled = true;
      };
      keymap = {
        "<C-k>" = [
          "select_prev"
          "fallback"
        ];
        "<C-j>" = [
          "select_next"
          "fallback"
        ];
        "<C-d>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-Space>" = [
          "select_and_accept"
          "fallback"
        ];
      };
      sources = {
        default =
          [
            "lsp"
            "path"
            "buffer"
          ]
          ++ (
            lib.optionals
            config.plugins.blink-cmp-git.enable
            ["git"]
          );

        providers =
          {}
          // (
            lib.optionalAttrs config.plugins.blink-cmp-git.enable
            {
              git = {
                module = "blink-cmp-git";
                name = "git";
                opts = {
                  commit = {};
                  git_centers = {github = {};};
                };
              };
            }
          );
      };
    };
  };
}
