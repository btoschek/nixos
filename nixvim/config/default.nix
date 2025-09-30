{
  imports = [
    ./options.nix
    ./keymaps.nix
  ];

  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
    };
  };
}
