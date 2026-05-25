{
  opts.formatexpr = "v:lua.require'conform'.formatexpr()";

  plugins.conform-nvim = {
    enable = true;

    settings = {
      formatters_by_ft = {
        rust = [
          "rustfmt"
        ];
        nix = [
          "alejandra"
        ];
      };

      formatters = {
        rustfmt = {
          options = {
            default_edition = "2021";
          };
        };
      };

      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
    };
  };
}
