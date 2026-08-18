import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import "../theme" as Theme
import "../services"

PanelWindow {
    id: selector

    property bool open: ThemeService.open
    property var targetScreen: null

    signal requestClose()

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    screen: targetScreen
    visible: open
    color: "transparent"

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#99000000"
        opacity: selector.open ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 180 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: selector.requestClose()
        }
    }

    FocusScope {
        id: keyboardScope

        anchors.fill: parent
        focus: true
        activeFocusOnTab: true

        Keys.onPressed: (event) => {
            event.accepted = true
        }

        Keys.onEscapePressed: {
            selector.requestClose()
        }

        Keys.onLeftPressed: {
            ThemeService.previous()
        }

        Keys.onRightPressed: {
            ThemeService.next()
        }

        Keys.onEnterPressed: {
            ThemeService.applyCurrent()
            selector.requestClose()
        }

        Keys.onReturnPressed: {
            ThemeService.applyCurrent()
            selector.requestClose()
        }

        ThemeModel {
            id: themeModel

            onThemesLoaded: {
                ThemeService.model = themeModel
                
                var count = ThemeService.count
                
                if (count > 0) {
                    if (!ThemeService.currentItem) {
                        ThemeService.select(0)
                    }
                    
                    if (ThemeService.currentItem) {
                        preview.theme = ThemeService.currentItem
                        carousel.updateSelection()
                    }
                }
            }
        }

        Column {
            id: content

            anchors.centerIn: parent
            spacing: 36

            opacity: selector.open ? 1 : 0
            scale: selector.open ? 1.0 : 0.95

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }

            ThemePreview {
                id: preview

                anchors.horizontalCenter: parent.horizontalCenter

                function updateTheme() {
                    theme = ThemeService.currentItem
                }
            }

            ThemeCarousel {
                id: carousel

                anchors.horizontalCenter: parent.horizontalCenter

                function updateSelection() {
                }
            }

        }
    }

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(function() {
                keyboardScope.forceActiveFocus()
                carousel.forceActiveFocus()
            })
            
            if (ThemeService.model && ThemeService.count > 0) {
                if (ThemeService.currentItem) {
                    preview.theme = ThemeService.currentItem
                }
            } else {
                if (themeModel.count > 0) {
                    ThemeService.model = themeModel
                    
                    if (!ThemeService.currentItem) {
                        ThemeService.select(0)
                    }
                    
                    if (ThemeService.currentItem) {
                        preview.theme = ThemeService.currentItem
                        carousel.updateSelection()
                    }
                } else {
                    themeModel.loadThemes()
                }
            }
        }
    }

    Connections {
        target: ThemeService

        function onCurrentItemChanged() {
            if (preview) {
                preview.theme = ThemeService.currentItem
            }
            carousel.updateSelection()
        }
    }
}