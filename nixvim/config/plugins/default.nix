{ config, ... }:

{
  imports = [
    ./blink-cmp.nix
    ./git.nix
    ./treesitter.nix
    ./lsp.nix
    ./conform.nix
  ];

  plugins.bufferline.enable = true;
}
