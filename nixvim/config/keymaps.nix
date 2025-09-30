# TODO: Make keybinds noremap & silent with function

{
  globals.mapleader = " ";

  keymaps = [
    # Map the leader key
    { mode = "n"; key = "<Space>"; action = "<NOP>"; }

    # Center search results
    { mode = "n"; key = "n"; action = "nzz"; }
    { mode = "n"; key = "N"; action = "Nzz"; }

    # Split windows faster
    { mode = "n"; key = "<Leader>sv"; action = "<CMD>split<CR>"; }
    { mode = "n"; key = "<Leader>sh"; action = "<CMD>vsplit<CR>"; }

    # Quicker navigation between windows
    { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
    { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
    { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
    { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }

    # Allow gf to open non-existant files
    { mode = "n"; key = "gf"; action = ":edit <cfile><CR>"; }

    # Reselect visual selection after indenting
    { mode = "v"; key = "<"; action = "<gv"; }
    { mode = "v"; key = ">"; action = ">gv"; }

    # Make Y behave like the other capitals
    { mode = "n"; key = "Y"; action = "y$"; }

    # Open the current file in the default program
    { mode = "n"; key = "<Leader>x"; action = ":!xdg-open %<CR><CR>"; }
  ];
}
