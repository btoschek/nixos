{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
  ];

  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
    };
  };
}
