import QtQuick
import "../services"
import "../theme" as Theme

Item {
    id: root

    width: 700
    height: 420

    property var theme: ThemeService.currentItem

    function getPaletteColors() {
        if (!theme || !theme.palette) {
            return getFallbackColors()
        }
        
        var paletteObj = Theme.Palettes.palettes[theme.palette]
        
        if (!paletteObj) {
            return getFallbackColors()
        }
                
        return [
            paletteObj.color4 || Theme.ThemeManager.color4 || "#666666",
            paletteObj.color5 || Theme.ThemeManager.color5 || "#888888",
            paletteObj.color7 || Theme.ThemeManager.color7 || "#ffffff",
            paletteObj.color8 || Theme.ThemeManager.color8 || "#aaaaaa",
            paletteObj.color9 || Theme.ThemeManager.color9 || "#cccccc"
        ]
    }
    
    function getFallbackColors() {
        return [
            Theme.ThemeManager.color4 || "#666666",
            Theme.ThemeManager.color5 || "#888888",
            Theme.ThemeManager.color7 || "#ffffff",
            Theme.ThemeManager.color8 || "#aaaaaa",
            Theme.ThemeManager.color9 || "#cccccc"
        ]
    }

    Image {
        id: preview
        anchors.fill: parent
        source: theme ? theme.preview : ""
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        smooth: true
        cache: true
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#00000000"
            }
            GradientStop {
                position: 0.55
                color: "#00000000"
            }
            GradientStop {
                position: 1
                color: "#D0000000"
            }
        }
    }

    Column {
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 24
        }
        spacing: 6
        visible: theme !== null && theme !== undefined

        Text {
            text: theme && theme.name ? theme.name : ""
            font.pixelSize: 28
            font.bold: true
            color: "white"
        }

        Text {
            visible: theme && theme.author !== undefined && theme.author !== null && theme.author !== ""
            text: theme && theme.author ? theme.author : ""
            color: "#cccccc"
            font.pixelSize: 15
        }

        Row {
            spacing: 8

            Repeater {
                model: getPaletteColors()

                Rectangle {
                    width: 20
                    height: 20
                    radius: 4
                    color: modelData || "#888888"
                    
                    Rectangle {
                        anchors.fill: parent
                        radius: 4
                        color: "transparent"
                        border.color: Qt.rgba(255, 255, 255, 0.2)
                        border.width: 1
                    }
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: !theme || theme === undefined
        text: "No theme selected\n\nWaiting for ThemeService.currentItem"
        horizontalAlignment: Text.AlignHCenter
        color: "white"
        font.pixelSize: 22
    }
}