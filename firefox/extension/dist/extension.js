"use strict";

const browserColours = (scheme) => ({
    bookmark_text: scheme.text,
    button_background_hover: scheme.surface1,
    button_background_active: scheme.surface2,
    icons: scheme.primary,
    icons_attention: scheme.primary,
    frame: scheme.mantle,
    frame_inactive: scheme.mantle,
    tab_text: scheme.text,
    tab_loading: scheme.primary,
    tab_background_text: scheme.subtext0,
    tab_selected: scheme.surface0,
    tab_line: scheme.surface0,
    toolbar: scheme.base,
    toolbar_text: scheme.text,
    toolbar_field_border: scheme.base,
    toolbar_field_border_focus: scheme.base,
    toolbar_field_text: scheme.subtext0,
    toolbar_field_text_focus: scheme.text,
    toolbar_field_highlight: scheme.primary,
    toolbar_field_highlight_text: scheme.base,
    toolbar_field_separator: scheme.base,
    toolbar_top_separator: scheme.mantle,
    toolbar_bottom_separator: scheme.base,
    toolbar_vertical_separator: scheme.surface1,
    ntp_background: scheme.base,
    ntp_card_background: scheme.surface0,
    ntp_text: scheme.text,
    popup: scheme.surface0,
    popup_border: scheme.surface1,
    popup_text: scheme.text,
    popup_highlight: scheme.primary,
    popup_highlight_text: scheme.base,
    sidebar: scheme.surface0,
    sidebar_border: scheme.surface2,
    sidebar_text: scheme.text,
    sidebar_highlight: scheme.surface2,
    sidebar_highlight_text: scheme.text,
});

const darkBrowserColours = (scheme) => ({
    ...browserColours(scheme),
    toolbar_field: scheme.surface0,
    toolbar_field_focus: scheme.surface0,
});

const lightBrowserColours = (scheme) => ({
    ...browserColours(scheme),
    toolbar_field: scheme.base,
    toolbar_field_focus: scheme.base,
});

// Opcional: sincronización con Dark Reader
let darkReader = null;
try {
    darkReader = browser.runtime.connect("addon@darkreader.org");
    darkReader.onDisconnect.addListener(() => {
        console.log("DarkReader disconnected:", darkReader?.error);
        darkReader = null;
    });
} catch (e) {
    console.log("DarkReader not found, skipping.");
}

// Conexión al native host
const nativePort = browser.runtime.connectNative("hathemefox");

nativePort.onMessage.addListener(msg => {
    console.log("Received message:", msg);

    const theme = {
        colors: msg.mode === "light" ? lightBrowserColours(msg) : darkBrowserColours(msg),
        properties: {
            color_scheme: msg.mode,
            content_color_scheme: msg.mode,
        },
    };

    browser.theme.update(theme);
    console.log("Theme updated.");

    if (darkReader) {
        darkReader.postMessage({
            type: "setTheme",
            data: {
                mode: msg.mode === "light" ? 0 : 1,
                [`${msg.mode}SchemeTextColor`]: msg.text,
                [`${msg.mode}SchemeBackgroundColor`]: msg.base,
            },
        });
        console.log("DarkReader theme updated.");
    }
});

console.log("HaThemeFox started.");
