pragma Singleton
import QtQuick
import Quickshell

Singleton {

    property QtObject colors

    colors: QtObject {

        property color background: "#24283b"
        property color foreground: "#c0caf5"

        // TODO: Figure out how to calculate this
        property color background_highlight: "#343955"

        property color green: "#9ece6a"
        property color red: "#f7768e"
        property color blue: "#7aa2f7"
        property color cyan: "#7dcfff"
        property color magenta: "#bb9af7"
        property color orange: "#ff9e64"
        property color purple: "#9d7cd8"
    }
}
