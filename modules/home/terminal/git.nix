{ config, ... }:

{
  programs.git = {
    enable = true;
    userName = "btoschek";
    userEmail = "btoschek@protonmail.com";
    signing = {
      format = "openpgp";
      key = "1AFEC0D7C7F14AB9";
      signByDefault = true;
    };
    delta = {
      enable = true;
    };
    extraConfig = {
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
  };

  programs.lazygit.enable = true;
}
