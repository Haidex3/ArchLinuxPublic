import Quickshell
import "modules/bar"
import "themeselector"
import Quickshell.Wayland
import Quickshell.Io
import "theme" as Theme

ShellRoot {

    readonly property var theme: Theme.ThemeManager

    property bool themeSelectorOpen: false

    Variants {
        model: Quickshell.screens.filter(scr => !isExcluded(scr.name))

        Bar {
            property var modelData
            screen: modelData
        }
    }
    
    ThemeSelector {
        id: themeSelector

        targetScreen: {
            let cursorScreen = Quickshell.screens.find(scr =>
                scr.geometry.contains(Quickshell.cursor.pos)
            )
            return cursorScreen || Quickshell.screens[0]
        }

        open: themeSelectorOpen

        onRequestClose: themeSelectorOpen = false
    }

    IpcHandler {
        target: "theme"

        function toggle(): void {
            themeSelectorOpen = !themeSelectorOpen
        }

        function open(): void {
            themeSelectorOpen = true
        }

        function close(): void {
            themeSelectorOpen = false
        }
    }

    function isExcluded(screenName) {
        const excluded = [
            // "DP-2",
        ];

        return excluded.includes(screenName);
    }
}