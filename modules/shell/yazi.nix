{den, ...}: {
  den.aspects.base.homeManager = {
    programs.yazi = {
      enable = true;

      # Automatically generate "auto-cd on leave" snippet for current shell
      shellWrapperName = "y";

      keymap = {
        mgr.append_keymap = [
          {
            on = ["g" "p"];
            run = "cd ~/Projects/";
            desc = "Go to Projects";
          }
          {
            on = ["g" "m"];
            run = "cd ~/Music/";
            desc = "Go to Music";
          }
          {
            on = ["g" "v"];
            run = "cd ~/Videos/";
            desc = "Go to Videos";
          }
          {
            on = ["g" "w"];
            run = "cd ~/Pictures/Wallpapers/";
            desc = "Go to Wallpapers";
          }
          # TODO: See https://github.com/sxyazi/yazi/discussions/4122
          {
            on = ["b" "w"];
            run = "shell --block -- ~/.local/bin/wallpaper \"%h\"";
            desc = "Set wallpaper";
          }
        ];
      };
    };
  };
}
