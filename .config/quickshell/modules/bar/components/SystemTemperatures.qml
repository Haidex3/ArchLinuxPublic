import QtQuick
import QtQuick.Layouts
import "../../../theme" as Theme
import "../../../services" as Services

/*!
    Group of inficator to know the status of the temp in PC's components
*/
Item {
    id: root
    implicitWidth: visible ? tempsRow.implicitWidth : 0
    implicitHeight: parent.height
    clip: true

    /*!
        Return color to indicate warning levels
    */
    function getTempColor(temp) {
        if (temp >= 80) return Theme.ThemeManager.color4
        if (temp >= 70) return Theme.ThemeManager.color5
        return Theme.ThemeManager.text
    }
    
    RowLayout {
        id: tempsRow
        anchors.centerIn: parent
        spacing: 10
        opacity: root.visible ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        // CPU Temperature
        RowLayout {
            visible: Services.TemperatureService.cpuTemp > 0
            spacing: 4
            
            Text {
                text: "󰍛"
                color: root.getTempColor(Services.TemperatureService.cpuTemp)
                font.pixelSize: Theme.ThemeManager.titleFontSize
                font.family: "Symbols Nerd Font"
            }
            
            Text {
                text: `${Math.round(Services.TemperatureService.cpuTemp)}°`
                color: root.getTempColor(Services.TemperatureService.cpuTemp)
                font.pixelSize: Theme.ThemeManager.baseFontSize
            }
        }

    }

    // Animation to toogle
    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
}