import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../../theme" as Theme
import "../../../services" as Services
import "../../../services"

/*!
    Group of controls to manage PC's components like network or volume
*/
Item {
    id: root

    property bool brightnessVisible: false

    implicitWidth: visible ? controlsRow.implicitWidth : 0
    implicitHeight: parent.height
    clip: true

    RowLayout {
        id: controlsRow
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.spacing - 5
        opacity: root.visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        // ==========================
        // NETWORK
        // ==========================
        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Text {
                anchors.centerIn: parent
                text: Services.NetworkService.ethernetEnabled ? "󰈀"
                        : (Services.NetworkService.wifiEnabled ? "󰖩" : "󰖪")
                color: (Services.NetworkService.ethernetEnabled ||
                        Services.NetworkService.wifiEnabled)
                    ? Theme.ThemeManager.color7
                    : Theme.ThemeManager.color4
                font.pixelSize: Theme.ThemeManager.baseFontSize + 4
                font.family: "Symbols Nerd Font"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.NetworkService.openNetworkManager()
            }
        }

        // ==========================
        // BLUETOOTH
        // ==========================
        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Text {
                anchors.centerIn: parent
                text: Services.BluetoothService.enabled ? "󰂯" : "󰂲"
                color: Services.BluetoothService.enabled
                    ? Theme.ThemeManager.color7
                    : Theme.ThemeManager.color4
                font.pixelSize: Theme.ThemeManager.titleFontSize
                font.family: "Symbols Nerd Font"
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.BluetoothService.openBluetoothManager()
            }
        }

        // ==========================
        // AUDIO
        // ==========================
        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24

            Text {
                id: aIconText
                anchors.centerIn: parent
                text: Services.AudioService.muted ? "󰖁"
                    : Services.AudioService.volume > 50 ? "󰕾" : "󰖀"
                color: Services.AudioService.muted
                    ? Theme.ThemeManager.color4
                    : Theme.ThemeManager.color7
                font.pixelSize: Theme.ThemeManager.titleFontSize + 2
                font.family: "Symbols Nerd Font"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.AudioService.openPavuControl()
            }
        }

        // ==========================
        // BRIGHTNESS
        // ==========================
        Item {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 24

            RowLayout {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: "󰃠"
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: Theme.ThemeManager.titleFontSize + 2
                    color: Theme.ThemeManager.color7
                }

                Text {
                    text: `${Services.BrightnessService.brightness}%`
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.baseFontSize
                    width: font.pixelSize * 3.4
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.brightnessVisible = !root.brightnessVisible
            }
        }


        // ==========================
        // BRIGHTNESS SLIDER CONTAINER
        // ==========================
        Item {
            id: brightnessContainer
            Layout.preferredWidth: root.brightnessVisible ? 140 : 0
            Layout.preferredHeight: 28
            clip: true

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }

            BrightnessSlider{
                anchors.fill: parent
            }
        }

        Battery {
                        id: batteryWidget
                    }
    }

    // ==========================
    // ROOT WIDTH ANIMATION
    // ==========================
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
