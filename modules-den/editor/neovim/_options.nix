{
  clipboard.register = "unnamedplus";

  opts = {
    backup = false; # Disable backup files
    completeopt = ["menuone" "noinsert" "noselect"]; # Don't select entries in completion by default
    fileencoding = "utf-8"; # File encoding
    fileformat = "unix"; # Use \n for line endings
    hidden = true; # When buffer goes out of sight, don't delete it
    ignorecase = true; # Ignore case in search patterns

    list = true; # Modify the look of some common special characters
    listchars = {
      tab = " ";
      trail = "·";
    }; # Highlight usage of tabs with arrows & hint at trailing whitespace

    mouse = "a"; # Allow mouse usage
    pumheight = 10; # Popup menu height

    scrolloff = 4; # How many lines to keep when scrolling
    sidescrolloff = 8; # Horizontal scrolloff

    cmdheight = 1; # More space in Neovim command line
    ruler = false; # Hide current cursor row and column from builtin statusbar
    showcmd = false; # Hide keystrokes from builtin statusbar
    showmode = false; # Don't show mode ('-- INSERT --')

    showtabline = 2; # Always show tabs
    smartcase = true; # Case-insensitive search when string doesn't start with uppercase character
    smartindent = true; # Smarter indentation

    splitbelow = true; # Split below, not above
    splitright = true; # Split to the right, not left

    swapfile = false; # Don't create swapfiles
    timeoutlen = 1000; # Set time after which Neovim interprets keystrokes
    # undodir =
    # undofile = true;
    updatetime = 300; # Faster completion
    writebackup = false; # Don't create backup files during save

    shiftwidth = 2; # Use indentation of x spaces
    tabstop = 2; # Convert tab to x spaces
    expandtab = true; # Convert tabs to spaces
    number = true; # Show absolute line numbers
    relativenumber = true; # Show relative line numbers

    wildmenu = true; # Show completions for editor commands when available
    wildmode = "list:full,full"; # Show full list of completions (editor commands)
    wrap = false; # Disable visual line wrapping
  };
}
