{ config, pkgs, ... }:

let
  background = ./sddm-background.mp4;
in
{
  environment.systemPackages = with pkgs; [
    (sddm-astronaut.override {
      embeddedTheme = "hyprland_kath";
      themeConfig = {
        ScreenWidth = "2560";
        ScreenHeight = "1440";

        Font = "pixelon"; # TODO: Change to be dynamic
        FontSize = "12";

        RoundCorners = "20";

        BackgroundPlaceholder = "Backgrounds/hyprland_kath.png";
        Background = "${background}";
        BackgroundSpeed = "1.0";
        PauseBackground = "";
        CropBackground = "false";
        BackgroundHorizontalAlignment = "center";
        BackgroundVerticalAlignment = "center";

        HeaderTextColor = "#b4d8ff";
        DateTextColor = "#b4d8ff";
        TimeTextColor = "#b4d8ff";

        FormBackgroundColor = "#242455";
        BackgroundColor = "#242455";
        DimBackgroundColor = "#242455";

        LoginFieldBackgroundColor = "#111111";
        PasswordFieldBackgroundColor = "#111111";
        LoginFieldTextColor = "#b4d8ff";
        PasswordFieldTextColor = "#b4d8ff";
        UserIconColor = "#b4d8ff";
        PasswordIconColor = "#b4d8ff";

        PlaceholderTextColor = "#bbbbbb";
        WarningColor = "#b4d8ff";

        LoginButtonTextColor = "#000055";
        LoginButtonBackgroundColor = "#b4d8ff";
        SystemButtonsIconsColor = "#b4d8ff";
        SessionButtonTextColor = "#b4d8ff";
        VirtualKeyboardButtonTextColor = "#b4d8ff";

        DropdownTextColor = "#000055";
        DropdownSelectedBackgroundColor = "#b4d8ff";
        DropdownBackgroundColor = "#90b4ff";

        HighlightTextColor = "#000055";
        HighlightBackgroundColor = "#b4d8ff";
        HighlightBorderColor = "transparent";

        HoverUserIconColor = "#fcfcff";
        HoverPasswordIconColor = "#fcfcff";
        HoverSystemButtonsIconsColor = "#fcfcff";
        HoverSessionButtonTextColor = "#fcfcff";
        HoverVirtualKeyboardButtonTextColor = "#fcfcff";

        PartialBlur = "true";
        FullBlur = "";
        BlurMax = "8";
        Blur = "2.0";

        HaveFormBackground = "true";
        FormPosition = "left";
      };
    })
  ];

  # NOTE: This is needed, regardless of using X11 or not
  services = {
    xserver.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        #wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";

        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtvirtualkeyboard
          kdePackages.qtmultimedia
        ];
      };
    };
  };
}
