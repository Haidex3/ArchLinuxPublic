interface Message {
    mode: "dark" | "light";
    rosewater: string;
    flamingo: string;
    pink: string;
    mauve: string;
    red: string;
    maroon: string;
    peach: string;
    yellow: string;
    green: string;
    teal: string;
    sky: string;
    sapphire: string;
    blue: string;
    lavender: string;
    text: string;
    subtext1: string;
    subtext0: string;
    overlay2: string;
    overlay1: string;
    overlay0: string;
    surface2: string;
    surface1: string;
    surface0: string;
    base: string;
    mantle: string;
    crust: string;
    success: string;
    error: string;
    primary: string;
    secondary: string;
    tertiary: string;
}

const browserColours = (scheme: Message) => ({
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

const darkBrowserColours = (scheme: Message) => ({
    ...browserColours(scheme),
    toolbar_field: scheme.surface0,
    toolbar_field_focus: scheme.surface0,
});

const lightBrowserColours = (scheme: Message) => ({
    ...browserColours(scheme),
    toolbar_field: scheme.base,
    toolbar_field_focus: scheme.base,
});

const darkReaderColours = (scheme: Message) => ({
    mode: scheme.mode === "light" ? 0 : 1,
    [`${scheme.mode}SchemeTextColor`]: scheme.text,
    [`${scheme.mode}SchemeBackgroundColor`]: scheme.base,
});

let darkReader: browser.runtime.Port | null = browser.runtime.connect("addon@darkreader.org");
darkReader.onDisconnect.addListener(() => {
    console.log("DarkReader disconnected:", darkReader?.error);
    darkReader = null;
});

browser.runtime.connectNative("hathemefox").onMessage.addListener(msg => {
    console.log("Received message:", msg);

    const res = msg as Message;
    const theme: browser._manifest.ThemeType = {
        colors: res.mode === "light" ? lightBrowserColours(res) : darkBrowserColours(res),
        properties: {
            color_scheme: res.mode,
            content_color_scheme: res.mode,
        },
    };
    browser.theme.update(theme);
    console.log("Theme updated.");

    if (darkReader !== null) {
        darkReader.postMessage({ type: "setTheme", data: darkReaderColours(res) });
        console.log("DarkReader theme updated.");
    }
});

console.log("HathemeFox started.");
