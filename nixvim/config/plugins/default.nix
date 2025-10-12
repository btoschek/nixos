{ config, ... }:

{
  imports = [
    ./blink-cmp.nix
    ./git.nix
    ./treesitter.nix
    ./lsp.nix
  ];

  plugins.bufferline.enable = true;
}
