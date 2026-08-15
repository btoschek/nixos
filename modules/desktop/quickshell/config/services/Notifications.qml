pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Notifications

QtObject {
    property NotificationServer notificationServer

    notificationServer: NotificationServer {
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => n.tracked = true
    }
}
