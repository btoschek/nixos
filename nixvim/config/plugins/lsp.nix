{lib, ...}: {
  plugins.lspconfig.enable = true;

  lsp = {
    servers = {
      # Rust
      rust_analyzer.enable = true;

      # Python
      ruff.enable = true;
    };

    # TODO: Add options (silent, noremap)
    keymaps = [
      {
        key = "gD";
        lspBufAction = "declaration";
      }
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        key = "gi";
        lspBufAction = "implementation";
      }
      {
        key = "<C-k>";
        lspBufAction = "signature_help";
      }
      {
        key = "<Space>wa";
        lspBufAction = "add_workspace_folder";
      }
      {
        key = "<Space>wr";
        lspBufAction = "remove_workspace_folder";
      }
      {
        key = "<Space>wl";
        action = lib.nixvim.mkRaw "function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end";
      }
      {
        key = "<Space>D";
        lspBufAction = "type_definition";
      }
      {
        key = "<Space>rn";
        lspBufAction = "rename";
      }
      {
        key = "<Space>ca";
        lspBufAction = "code_action";
      }
      {
        key = "gr";
        lspBufAction = "references";
      }
    ];

    luaConfig.post = ''
      -- Change diagnostic symbols
      local signs = { Error = '', Warn = '', Hint = '', Info = '' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    '';
  };

  plugins.fidget.enable = true;
}
