import QtQuick
import "../theme" as Theme

Rectangle {
    id: root

    property var theme
    property bool selected: false
    signal clicked()

    width: selected ? 230 : 180
    height: selected ? 260 : 210
    radius: 18
    color: "#202020"
    border.width: selected ? 2 : 0

    border.color: {
        if (!theme || !theme.palette) return "#ffffff"
        var paletteObj = Theme.Palettes.palettes[theme.palette]
        return paletteObj ? paletteObj.color4 : "#ffffff"
    }

    scale: selected ? 1.08 : 0.88
    opacity: selected ? 1 : 0.55

    Behavior on scale {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 220
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 220
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 220
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        Image {
            width: parent.width
            height: 150
            source: theme ? theme.preview : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            clip: true
        }

        Text {
            text: theme ? theme.name : ""
            color: "white"
            font.pixelSize: 18
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Repeater {
                model: {
                    if (!theme || !theme.palette) return []
                    var paletteObj = Theme.Palettes.palettes[theme.palette]
                    if (!paletteObj) return []
                    return [
                        paletteObj.color4,
                        paletteObj.color5,
                        paletteObj.color7,
                        paletteObj.color8,
                        paletteObj.color9
                    ]
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 4
                    color: modelData
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}