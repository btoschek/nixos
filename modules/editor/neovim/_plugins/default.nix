{config, ...}: {
  imports = [
    ./blink-cmp.nix
    ./git.nix
    ./treesitter.nix
    ./lsp.nix
    ./conform.nix
    ./snacks.nix
    ./folding.nix
  ];

  # Bufferline
  plugins.bufferline.enable = true;
  plugins.web-devicons.enable = true;
}
