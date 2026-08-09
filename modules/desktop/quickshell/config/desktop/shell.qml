import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {
  id: root

  property string fontFamily: "Hack Nerd Font"
  property string colorClock: "#7aa2f7"
  property string colorDate: "#bb8af7"

  Variants {

    // Create panel once on each monitor
    model: Quickshell.screens

    PanelWindow {

      // TODO: Check
      property var modelData
      screen: modelData

      aboveWindows: false

      color: "transparent"

      anchors {
        bottom: true
        right: true
      }

      margins {
        bottom: 60
        right: 100
      }

      implicitWidth: content.width
      implicitHeight: content.height

      ColumnLayout {
        id: content

        spacing: -60

        Text {
          id: clock

          color: root.colorClock

          font {
            pixelSize: 55
            family: root.fontFamily
          }

          Layout.alignment: Qt.AlignCenter

          Process {
            id: procClock

            command: ["date", "+%H:%M"]
            running: true

            stdout: StdioCollector {
              onStreamFinished: clock.text = this.text
            }
          }
        }

        Text {
          id: date

          color: root.colorDate

          font {
            pixelSize: 25
            family: root.fontFamily
          }

          Layout.alignment: Qt.AlignCenter

          Process {
            id: procDate

            command: ["date", "+%A, %d.%m."]
            running: true

            stdout: StdioCollector {
              onStreamFinished: date.text = this.text
            }
          }
        }

        Timer {
          interval: 1000
          running: true
          repeat: true
          onTriggered: {
            procClock.running = true
            procDate.running = true
          }
        }
      }
    }
  }
}
