import "modules/common"
import "modules/overlays"
import "modules/quickshell"
import "modules/notifications"
import "services"

import Quickshell

ShellRoot {
    id: root

    ReloadPopup {}

    WallpaperTimeOverlay {}

    NotificationPopups {}
}
