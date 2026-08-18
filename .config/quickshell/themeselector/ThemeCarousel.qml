import QtQuick
import QtQuick.Layouts
import "../services"

FocusScope {
    id: root

    width: 900
    height: 320

    focus: true
    activeFocusOnTab: true

    property var themeModel: ThemeService.model
    property int visibleCount: 7
    property int firstVisibleIndex: 0
    property int centerOffset: Math.floor(visibleCount / 2)
    property bool previewOnHover: true

    Keys.onLeftPressed: {
        if (ThemeService.currentIndex > 0) {
            ThemeService.previous()
            centerOnCurrentIndex()
            updateSelection()
        }
    }
    
    Keys.onRightPressed: {
        if (ThemeService.currentIndex < ThemeService.count - 1) {
            ThemeService.next()
            centerOnCurrentIndex()
            updateSelection()
        }
    }
    
    Keys.onReturnPressed: {
        event.accepted = false
    }
    
    Keys.onEnterPressed: {
        event.accepted = false
    }

    Rectangle {
        id: leftArrow
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
        width: 40
        height: 40
        radius: 20
        color: firstVisibleIndex > 0 ? "#44000000" : "#22000000"
        visible: ThemeService.count > visibleCount
        opacity: firstVisibleIndex > 0 ? 0.8 : 0.3
        
        Text {
            anchors.centerIn: parent
            text: "◀"
            color: "white"
            font.pixelSize: 20
        }
        
        MouseArea {
            anchors.fill: parent
            enabled: firstVisibleIndex > 0
            onClicked: {
                firstVisibleIndex = Math.max(0, firstVisibleIndex - 1)
                updateSelection()
            }
        }
    }

    Rectangle {
        id: rightArrow
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 10
        }
        width: 40
        height: 40
        radius: 20
        color: firstVisibleIndex + visibleCount < ThemeService.count ? "#44000000" : "#22000000"
        visible: ThemeService.count > visibleCount
        opacity: firstVisibleIndex + visibleCount < ThemeService.count ? 0.8 : 0.3
        
        Text {
            anchors.centerIn: parent
            text: "▶"
            color: "white"
            font.pixelSize: 20
        }
        
        MouseArea {
            anchors.fill: parent
            enabled: firstVisibleIndex + visibleCount < ThemeService.count
            onClicked: {
                firstVisibleIndex = Math.min(ThemeService.count - visibleCount, firstVisibleIndex + 1)
                updateSelection()
            }
        }
    }

    Item {
        id: carouselContainer
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
        clip: false
        
        Behavior on x {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutCubic
            }
        }

        Row {
            id: carouselRow
            spacing: 20

            Repeater {
                id: repeater
                model: ThemeService.count

                ThemeCard {
                    id: card
                    width: 200
                    height: 280
                    
                    visible: index >= firstVisibleIndex && index < firstVisibleIndex + visibleCount
                    
                    theme: ThemeService.model ? ThemeService.model.get(index) : null
                    selected: index === ThemeService.currentIndex
                    
                    onClicked: {
                        ThemeService.select(index)
                        centerOnCurrentIndex()
                        ThemeService.applyCurrent()
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.NoButton
                        
                        onEntered: {
                            if (previewOnHover && index !== ThemeService.currentIndex) {
                                ThemeService.select(index)
                                centerOnCurrentIndex()
                                updateSelection()
                            }
                        }
                    }
                }
            }
        }

        function calculateX() {
            var totalCards = ThemeService.count
            if (totalCards === 0) return 0
            
            var cardWidth = 200
            var spacing = 20
            var totalWidth = visibleCount * (cardWidth + spacing) - spacing
            var containerWidth = root.width - 80
            
            if (totalCards <= visibleCount) {
                var actualWidth = totalCards * (cardWidth + spacing) - spacing
                return (containerWidth - actualWidth) / 2
            }
            
            var current = ThemeService.currentIndex
            var centerOffset = 3
            
            var targetCard = current
            
            if (current < centerOffset) {
                targetCard = centerOffset
            } else if (current > totalCards - 1 - centerOffset) {
                targetCard = totalCards - 1 - centerOffset
            }
            
            var cardsBefore = targetCard
            var xOffset = -(cardsBefore * (cardWidth + spacing)) + (containerWidth / 2) - (cardWidth / 2)
            
            var maxX = 0
            var minX = -(totalCards * (cardWidth + spacing) - spacing - containerWidth)
            xOffset = Math.max(minX, Math.min(maxX, xOffset))
            
            return xOffset
        }
    }

    function centerOnCurrentIndex() {
        var totalCount = ThemeService.count
        if (totalCount === 0) return
        
        var current = ThemeService.currentIndex
        var halfVisible = Math.floor(visibleCount / 2)
        
        var newFirstVisible = current - halfVisible
        
        if (newFirstVisible < 0) {
            newFirstVisible = 0
        } else if (newFirstVisible + visibleCount > totalCount) {
            newFirstVisible = Math.max(0, totalCount - visibleCount)
        }
        
        firstVisibleIndex = newFirstVisible
        
        var container = carouselContainer
        if (container) {
            container.x = container.calculateX()
        }
    }

    function updateSelection() {
        for (var i = 0; i < repeater.count; i++) {
            var card = repeater.itemAt(i)
            if (card) {
                card.selected = (i === ThemeService.currentIndex)
            }
        }
    }

    Connections {
        target: ThemeService
        
        function onCurrentIndexChanged() {
            centerOnCurrentIndex()
            updateSelection()
        }
        
        function onModelChanged() {
            if (ThemeService.count > 0) {
                var middleIndex = Math.floor(ThemeService.count / 2)
                ThemeService.select(middleIndex)
                centerOnCurrentIndex()
            } else {
                firstVisibleIndex = 0
            }
            updateSelection()
        }
        
        function onCountChanged() {
            if (ThemeService.count > 0) {
                centerOnCurrentIndex()
            } else {
                firstVisibleIndex = 0
            }
            updateSelection()
        }
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            if (ThemeService.count > 0) {
                var middleIndex = Math.floor(ThemeService.count / 2)
                ThemeService.select(middleIndex)
                centerOnCurrentIndex()
            }
            updateSelection()
        })
    }
}