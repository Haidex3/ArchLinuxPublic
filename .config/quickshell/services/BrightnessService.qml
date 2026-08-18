pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property int brightness: 50

    function log(msg) {
        console.log("[BrightnessService]", msg)
    }

    function updateBrightness() {
        getProc.command = ["/bin/bash", "-c",
            "current=$(brightnessctl g); max=$(brightnessctl m); echo $(( current * 100 / max ))"]
        getProc.running = true
    }

    function setBrightness(value) {
        value = Math.max(0, Math.min(100, value))
        root.brightness = value

        setProc.command = ["/bin/bash", "-c", "brightnessctl s " + value + "%"]
        setProc.running = true
    }

    Process {
        id: getProc
        running: false
        command: []

        stdout: SplitParser {
            onRead: function(data) {
                const parsed = parseInt(data.trim())
                if (!isNaN(parsed))
                    root.brightness = parsed
            }
        }

        onExited: function(exitCode) {
            if (exitCode !== 0)
                log("Error leyendo brillo")
        }
    }

    Process {
        id: setProc
        running: false
        command: []

        stdout: SplitParser {
            onRead: function(data) {
                const parsed = parseInt(data.trim())
                if (!isNaN(parsed))
                    root.brightness = parsed
            }
        }

        onExited: function(exitCode) {
            if (exitCode !== 0) {
                root.updateBrightness()
            }
        }
    }

    property Timer _pollTimer: Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: root.updateBrightness()
    }

    Component.onCompleted: updateBrightness()
}
