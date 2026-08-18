pragma Singleton

import QtQuick
import QtQml
import Quickshell.Io
import "../themeselector"

QtObject {
    id: root

    property bool open: false
    property int currentIndex: 0
    property string currentTheme: ""
    property var model: null

    // Proceso para ejecutar el script de tema
    property Process _themeProcess: Process {
        running: false
        command: ["sh", "-c", ""]
        
        stdout: SplitParser {
            onRead: data => console.log("Theme output:", data.trim())
        }
        
        stderr: SplitParser {
            onRead: data => console.error("Theme error:", data.trim())
        }
        
        onExited: {
            console.log("Theme process exited with code:", exitCode)
            // Limpiar el comando después de ejecutar
            command = ["sh", "-c", ""]
        }
    }

    readonly property int count: {
        if (model && typeof model.count !== 'undefined') {
            return model.count
        }
        return 0
    }

    readonly property var currentItem: {
        if (model && count > 0 && typeof model.get === 'function') {
            var item = model.get(currentIndex)
            return item
        }
        return null
    }

    function show() {
        open = true
    }

    function hide() {
        open = false
    }

    function toggle() {
        open = !open
    }

    function next() {
        if (count === 0)
            return

        currentIndex++

        if (currentIndex >= count)
            currentIndex = 0
        
        console.log("ThemeService: Next theme index:", currentIndex, "name:", currentItem?.name)
    }

    function previous() {
        if (count === 0)
            return

        currentIndex--

        if (currentIndex < 0)
            currentIndex = count - 1
        
        console.log("ThemeService: Previous theme index:", currentIndex, "name:", currentItem?.name)
    }

    function select(index) {
        if (count === 0)
            return

        if (index < 0 || index >= count)
            return

        currentIndex = index
        console.log("ThemeService: Selected theme index:", index, "name:", currentItem?.name)
    }

    function applyCurrent() {
        if (!currentItem) {
            console.warn("ThemeService: No current item to apply")
            return
        }

        console.log("ThemeService: Applying theme:", currentItem.name, "ID:", currentItem.id)

        currentTheme = currentItem.id

        // Construir el comando completo
        var scriptPath = "/home/Haider/scripts/scheme/set.sh"
        var fullCommand = scriptPath + " " + currentItem.id
        
        console.log("ThemeService: Executing:", fullCommand)
        
        // Ejecutar el script con Process
        _themeProcess.command = ["sh", "-c", fullCommand]
        _themeProcess.running = true
        
        hide()
    }

    function getThemeIndex(id) {
        if (!model || count === 0) return -1
        
        for (var i = 0; i < count; i++) {
            var item = model.get(i)
            if (item && item.id === id) {
                return i
            }
        }
        return -1
    }

    function loadTheme(id) {
        var index = getThemeIndex(id)
        if (index >= 0) {
            select(index)
        } else {
            console.warn("ThemeService: Theme not found:", id)
        }
    }

    Component.onCompleted: {
        console.log("ThemeService initialized with", count, "themes")
    }
}