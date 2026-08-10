import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Scope {
  id: root

  NotificationServer {
    id: server

    actionsSupported: true
    bodySupported: true
    imageSupported: true

    onNotification: n => n.tracked = true
  }

  PanelWindow {

    anchors { top: true; right: true }
    margins { top: 12; right: 12 }

    implicitWidth: 440
    implicitHeight: column.implicitHeight
    color: "transparent"

    // Prevent window manager from allocating space for widget
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 15

      Repeater {
        model: server.trackedNotifications

        delegate: ClippingRectangle {

          id: card
          required property var modelData

          property color cardColor:
            modelData.urgency === NotificationUrgency.Critical
              ? Config.colors.red
              : Config.colors.purple

          // Automatically dismiss non-critical messages after specified timeout
          Timer {
            running: card.modelData.urgency !== NotificationUrgency.Critical
            interval: Config.notifications.timeout
            onTriggered: card.modelData.dismiss()
          }

          Layout.fillWidth: true
          Layout.preferredHeight: layout.implicitHeight
          radius: 8
          color: Config.colors.bg
          border.width: 2
          border.color: Config.colors.bg_highlight

          // Make border cover the outside of the container
          contentUnderBorder: true

          RowLayout {

            id: layout
            spacing: 5

            width: parent.width

            // Notification type indicator
            Rectangle {
              width: 20
              Layout.fillHeight: true
              color: card.cardColor
            }

            // Notification content
            RowLayout {

              Layout.margins: 10

              Image {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80
                fillMode: Image.PreserveAspectFit
                visible: source.toString() !== ""
                source: card.modelData.image || card.modelData.appIcon || ""
              }

              // Spacer (for additional margin between elements)
              Rectangle { }

              // Notification content
              ColumnLayout {
                spacing: 10

                width: parent.width

                Text {
                  Layout.fillWidth: true
                  text: card.modelData.summary
                  color: Config.colors.fg
                  font.family: "Hack Nerd Font"
                  font.pixelSize: 16
                  font.bold: true
                  elide: Text.ElideRight
                }

                Text {
                  Layout.fillWidth: true
                  visible: text !== ""
                  text: card.modelData.body
                  color: Config.colors.fg
                  font.family: "Hack Nerd Font"
                  font.pixelSize: 16 - 4
                  wrapMode: Text.WrapAnywhere
                }
              }
            }
          }

          // Make notification go away by clicking on it
          MouseArea {
            anchors.fill: parent
            onClicked: card.modelData.dismiss()
          }
        }
      }
    }
  }
}
