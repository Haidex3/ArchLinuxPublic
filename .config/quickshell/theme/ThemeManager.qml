pragma Singleton
import QtQuick
import Qt.labs.platform
import "." as Local

Item {
    id: themeManager
    width: 0
    height: 0
    visible: false

    readonly property string stateFile:
        StandardPaths.writableLocation(StandardPaths.HomeLocation)
        + "/.local/state/hatheme/scheme/current-theme.txt"

    property string currentTheme: "dark-rose-pine"

    readonly property var availableThemes:
        Object.keys(Local.Palettes.palettes)

    property var palette:
        Local.Palettes.palettes[currentTheme] || {}

    readonly property color base:    palette.base    || "#000000"
    readonly property color surface: palette.surface || "#000000"
    readonly property color text:    palette.text    || "#ffffff"

    readonly property color color1:  palette.color1  || base
    readonly property color color2:  palette.color2  || base
    readonly property color color3:  palette.color3  || base
    readonly property color color4:  palette.color4  || base
    readonly property color color5:  palette.color5  || base
    readonly property color color6:  palette.color6  || base
    readonly property color color7:  palette.color7  || base
    readonly property color color8:  palette.color8  || base
    readonly property color color9:  palette.color9  || base
    readonly property color color10: palette.color10 || base
    readonly property color color11: palette.color11 || base
    readonly property color color12: palette.color12 || base

    readonly property int baseFontSize: 11
    readonly property int titleFontSize: 13
    readonly property int smallFontSize: 9

    readonly property int spacing: 10
    readonly property int barComponentsSpacing: 30
    readonly property int margin: 1
    readonly property int marginItems: 15

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: themeManager.readThemeState()
    }

    function readThemeState() {
        const xhr = new XMLHttpRequest()
        const url = stateFile + "?t=" + Date.now()

        xhr.open("GET", url)

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return

            if (xhr.status !== 0 && xhr.status !== 200) {
                return
            }
            
            const theme = xhr.responseText.trim()

            if (!theme) {
                return
            }

            if (!Local.Palettes.palettes[theme]) {
                return
            }

            if (theme !== currentTheme) {
                currentTheme = theme
            }
        }

        xhr.send()
    }

    function getThemeDisplayName(themeName) {
        return themeName
            .replace(/^dark-/, "")
            .replace(/^light-/, "")
            .replace(/-/g, " ")
            .replace(/\b\w/g, c => c.toUpperCase())
            + (themeName.startsWith("dark-") ? " Dark" : " Light")
    }
}