{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        bibtex
        c
        css
        html
        javascript
        json
        latex
        lua
        make
        markdown
        nix
        python
        regex
        rust
        scss
        sql
        toml
        typst
        vim
        vimdoc
        yaml
        yuck
      ];
    };
  };
}
