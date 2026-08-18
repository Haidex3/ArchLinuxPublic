import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "components"
import "layout"
import "../../widgets" as Widgets

PanelWindow {
    id: bar

    anchors {
        left: true
        top: true
        right: true
    }

    implicitHeight: 35
    color: "transparent"

    property var modelData
    property bool mediaOpen: false

    screen: modelData

    // =============================
    // CENTER SECTION
    // =============================
    Item {
        id: leftSection

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: leftRow.implicitWidth

        RowLayout {
            id: leftRow

            anchors.fill: parent
            spacing: 0

            BarConnector { mirrored: true }

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: leftContent.implicitWidth + (Theme.ThemeManager.margin * 2)
                color: Theme.ThemeManager.base

                Rectangle {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        right: parent.right
                    }
                    height: 1.5
                    color: Theme.ThemeManager.color12
                }

                RowLayout {
                    id: leftContent

                    anchors.fill: parent
                    anchors.leftMargin: Theme.ThemeManager.margin
                    anchors.rightMargin: Theme.ThemeManager.margin
                    spacing: Theme.ThemeManager.spacing

                    Item { Layout.preferredWidth: 4 }

                    Clock {}

                    ToggleIndicator {
                        id: controlsToggle
                        icon: "󰒓"
                    }

                    // MEDIA BUTTON
                    ToggleIndicator {
                        id: mediaToggle
                        icon: "󰎆"
                        expanded: bar.mediaOpen

                        onExpandedChanged: {
                            bar.mediaOpen = expanded
                        }
                    }

                    SystemControls {
                        visible: controlsToggle.expanded
                    }

                    Item { Layout.preferredWidth: 4 }
                }
            }

            BarConnector {}
        }
    }

    // =============================
    // LEFT SECTION
    // =============================
    Item {
        id: centerSection

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: centerRow.implicitWidth

        RowLayout {
            id: centerRow
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: Math.max(
                    100,
                    workspacesRow.implicitWidth + (Theme.ThemeManager.spacing * 4)
                )
                color: Theme.ThemeManager.base

                Rectangle {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        right: parent.right
                    }
                    height: 1.5
                    color: Theme.ThemeManager.color12
                }

                RowLayout {
                    id: workspacesRow
                    anchors.centerIn: parent

                    Workspaces {}
                }

                RowLayout {
                    id: power
                    anchors.centerIn: parent

                    PowerProfile {}
                }
            }

            BarConnector {}
        }
    }

    // =============================
    // RIGHT SECTION
    // =============================
    Item {
        id: rightSection

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        width: rightRow.implicitWidth

        RowLayout {
            id: rightRow
            anchors.fill: parent
            spacing: 0

            BarConnector { mirrored: true }

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: rightContent.implicitWidth + (Theme.ThemeManager.margin * 2)
                color: Theme.ThemeManager.base

                Rectangle {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        right: parent.right
                    }
                    height: 1.5
                    color: Theme.ThemeManager.color12
                }

                RowLayout {
                    id: rightContent
                    anchors.fill: parent
                    spacing: Theme.ThemeManager.spacing

                    Item { Layout.preferredWidth: 4 }

                    SystemTemperatures {
                        visible: tempToggle.expanded
                    }

                    PowerProfile {
                        id: powerProfile
                        visible: tempToggle.expanded
                    }


                    ToggleIndicator {
                        id: tempToggle
                        icon: "󰔏"
                    }

                    SystemMetrics {
                        visible: metricsToggle.expanded
                    }

                    ToggleIndicator {
                        id: metricsToggle
                        icon: "󰕮"
                    }

                    Item { Layout.preferredWidth: 4 }

                }
            }
        }
    }

    // =============================
    // MEDIA PANEL (Overlay real)
    // =============================
    Widgets.MediaPanel {
        id: mediaPanel
        targetScreen: bar.screen
        open: bar.mediaOpen

        onRequestClose: {
            bar.mediaOpen = false
            mediaToggle.expanded = false
        }
    }

}
