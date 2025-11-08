{ config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "btoschek";
        email = "btoschek@protonmail.com";
      };

      init.defaultBranch = "main";

      # Clone GitHub projects with gh:btoschek/lorelei
      "url \"git@github.com:\"" = {
        insteadOf = "gh:";
      };

      # Clone personal GitHub projects with bt:lorelei
      "url \"git@github.com:btoschek/\"" = {
        insteadOf = "bt:";
      };
    };
    signing = {
      format = "openpgp";
      key = "1AFEC0D7C7F14AB9";
      signByDefault = true;
    };
  };

  programs.delta.enable = true;
  programs.lazygit.enable = true;
}
