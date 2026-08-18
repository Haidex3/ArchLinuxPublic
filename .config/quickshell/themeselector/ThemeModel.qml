import QtQuick
import QtQml
import Qt.labs.platform
import Qt.labs.folderlistmodel

QtObject {
    id: root

    readonly property string themesDir: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/share/hatheme/themes"
    readonly property string imagesDir: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.local/share/hatheme/images"
    
    property var themes: []
    property int count: 0

    signal themesLoaded()

    function get(index) {
        if (index < 0 || index >= themes.length)
            return null
        return themes[index]
    }

    function loadThemes() {
        themes = []
        count = 0
        
        var folderModel = Qt.createQmlObject('
            import QtQuick
            import Qt.labs.folderlistmodel
            
            FolderListModel {
                folder: "' + themesDir + '"
                nameFilters: ["*.txt"]
                showDirs: false
                showDotAndDotDot: false
                sortField: FolderListModel.Name
            }
        ', root, "FolderListModel")
        
        if (!folderModel) {
            themesLoaded()
            return
        }
        
        function processThemes(model) {
            var imageFiles = []
            
            var imageModel = Qt.createQmlObject('
                import QtQuick
                import Qt.labs.folderlistmodel
                
                FolderListModel {
                    folder: "' + imagesDir + '"
                    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.svg"]
                    showDirs: false
                    showDotAndDotDot: false
                }
            ', root, "ImageListModel")
            
            if (imageModel) {
                for (var k = 0; k < imageModel.count; k++) {
                    var imgName = imageModel.get(k, "fileName")
                    imageFiles.push(imgName)
                }
                imageModel.destroy()
            }
            
            var newThemes = []
            
            for (var i = 0; i < model.count; i++) {
                var fileName = model.get(i, "fileName")
                
                if (fileName.endsWith(".txt")) {
                    var themeName = fileName.substring(0, fileName.length - 4)
                    var previewPath = findPreviewImage(themeName, imageFiles)
                    
                    var themeObj = {
                        id: themeName,
                        name: themeName.charAt(0).toUpperCase() + themeName.slice(1).replace(/-/g, " "),
                        palette: themeName,
                        preview: previewPath
                    }
                    
                    newThemes.push(themeObj)
                }
            }
            
            themes = newThemes
            count = themes.length
            
            if (folderModel) folderModel.destroy()
            
            themesLoaded()
        }
        
        function findPreviewImage(themeName, imageFiles) {
            var possibleNames = [
                themeName + ".png",
                themeName + ".jpg",
                themeName + ".jpeg",
                themeName + ".svg",
                themeName + "-M2.png",
                themeName + "-M2.jpg",
                themeName + ".PNG",
                themeName + ".JPG"
            ]
            
            for (var i = 0; i < possibleNames.length; i++) {
                for (var j = 0; j < imageFiles.length; j++) {
                    if (imageFiles[j] === possibleNames[i]) {
                        return imagesDir + "/" + possibleNames[i]
                    }
                }
            }
            
            return imagesDir + "/" + themeName + ".png"
        }
        
        function onStatusChanged() {
            if (folderModel.status === FolderListModel.Ready) {
                processThemes(folderModel)
            } else if (folderModel.status === FolderListModel.Error) {
                createDirectoryIfNeeded()
            }
        }
        
        folderModel.statusChanged.connect(onStatusChanged)
        
        if (folderModel.status === FolderListModel.Ready) {
            processThemes(folderModel)
        }
    }

    function createDirectoryIfNeeded() {
        try {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + themesDir + "/", false)
            xhr.send()
            
            if (xhr.status === 200 || xhr.status === 0) {
                createExampleTheme()
                Qt.callLater(function() { loadThemes() })
            } else {
                createDirectory()
            }
        } catch (e) {
            createDirectory()
        }
    }
    
    function createDirectory() {
        Qt.callLater(function() {
            createExampleTheme()
            Qt.callLater(function() { loadThemes() })
        })
    }
    
    function createExampleTheme() {
        var exampleContent = 'name Catppuccin Mocha\npalette dark-catppuccin\npreview catppuccin.png'
        var examplePath = themesDir + "/catppuccin.txt"
        
        try {
            var xhr = new XMLHttpRequest()
            xhr.open("PUT", "file://" + examplePath, false)
            xhr.send(exampleContent)
        } catch (e) {
            console.warn("Could not create example theme:", e)
        }
    }

    function reload() {
        loadThemes()
    }

    Component.onCompleted: {
        loadThemes()
    }
}