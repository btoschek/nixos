{
  plugins.luasnip = {
    enable = true;

    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
      update_events = [
        "TextChanged"
        "TextChangedI"
      ];

      ext_opts = {
        "types.choiceNode" = {
          active = {
            virt_text = [["●" "Number"]];
          };
        };
        "types.insertNode" = {
          active = {
            virt_text = [["●" "Constant"]];
          };
        };
      };
    };
  };
}
