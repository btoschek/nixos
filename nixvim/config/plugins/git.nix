{
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
      signs = {
        add = {
          text = "│";
        };
        change = {
          text = "│";
        };
        changedelete = {
          text = "~";
        };
        delete = {
          text = "_";
        };
        topdelete = {
          text = "‾";
        };
      };
    };
  };
}
