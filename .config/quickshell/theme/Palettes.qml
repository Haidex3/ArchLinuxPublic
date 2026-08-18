pragma Singleton
import QtQuick

QtObject {
    readonly property var palettes: {

        // =========================================================
        // Rosé Pine
        // =========================================================
        "dark-rose-pine": {
            base: "#191724",
            surface: "#F2CDCD",
            text: "#F5C2E7",
            color1: "#161616",
            color2: "#1E1E1E",
            color3: "#262626",
            color4: "#EB6F92",
            color5: "#F6C177",
            color6: "#EBCBBA",
            color7: "#31748F",
            color8: "#9CCFD8",
            color9: "#C4A7E7",
            color10: "#1F1D2E",
            color11: "#403D52",
            color12: "#F5C2E7"
        },

        "light-rose-pine": {
            base: "#F8E6EE",
            surface: "#E8CFDA",
            text: "#C06A78",
            color1: "#FFF0F6",
            color2: "#2E8F59",
            color3: "#B8892F",
            color4: "#B3264A",
            color5: "#B8892F",
            color6: "#E6A3B4",
            color7: "#3E84C4",
            color8: "#4FA3B3",
            color9: "#9C5BC6",
            color10: "#FFEAF1",
            color11: "#F2D2DF",
            color12: "#C06A78"
        },

        // =========================================================
        // Neon
        // =========================================================
        "dark-neon": {
            base: "#0B0612",
            surface: "#121212",
            text: "#D946EF",
            color1: "#0E0E0E",
            color2: "#1E1E1E",
            color3: "#262626",
            color4: "#FB7185",
            color5: "#FACC15",
            color6: "#6b126f",
            color7: "#06B6D4",
            color8: "#8AB4F8",
            color9: "#C026D3",
            color10: "#0B0612",
            color11: "#140A1F",
            color12: "#D946EF"
        },

        "light-neon": {
            base: "#FAF7FF",
            surface: "#F0EBF8",
            text: "#C026D3",
            color1: "#FFFFFF",
            color2: "#F6F1FB",
            color3: "#F0EBF8",
            color4: "#EC4899",
            color5: "#FACC15",
            color6: "#E11D48",
            color7: "#06B6D4",
            color8: "#C026D3",
            color9: "#A21CAF",
            color10: "#FAF7FF",
            color11: "#F0EBF8",
            color12: "#C026D3"
        },

        // =========================================================
        // Sunrise
        // =========================================================
        "dark-sunrise": {
            base: "#12100E",
            surface: "#121212",
            text: "#FF9E64",
            color1: "#161616",
            color2: "#262626",
            color3: "#2E2E2E",
            color4: "#FB7185",
            color5: "#F2C97D",
            color6: "#F97316",
            color7: "#F59E0B",
            color8: "#FDBA74",
            color9: "#F43F5E",
            color10: "#241014",
            color11: "#3A1A1F",
            color12: "#FF9E64"
        },

        "light-sunrise": {
            base: "#F8E7D4",
            surface: "#F1E6DA",
            text: "#F19762",
            color1: "#F7EEE4",
            color2: "#EADCCF",
            color3: "#E3D4C6",
            color4: "#F28C8C",
            color5: "#E0AF68",
            color6: "#F28C8C",
            color7: "#E0AF68",
            color8: "#FFBD8A",
            color9: "#F43F5E",
            color10: "#F8E7D4",
            color11: "#F1E6DA",
            color12: "#F19762"
        },

        // =========================================================
        // Ocean
        // =========================================================
        "dark-ocean": {
            base: "#0E1A22",
            surface: "#121212",
            text: "#4FB6C6",
            color1: "#0E0E0E",
            color2: "#161616",
            color3: "#262626",
            color4: "#38BDF8",
            color5: "#22D3EE",
            color6: "#06B6D4",
            color7: "#5FA8A0",
            color8: "#7A8FD4",
            color9: "#5FA8A0",
            color10: "#0B1623",
            color11: "#13293D",
            color12: "#4FB6C6"
        },

        "light-ocean": {
            base: "#F3FAFC",
            surface: "#F3FAFC",
            text: "#4FB6C6",
            color1: "#EDF6F9",
            color2: "#D6E6EC",
            color3: "#E2EEF3",
            color4: "#0284C7",
            color5: "#06B6D4",
            color6: "#5FA8A0",
            color7: "#5FA8A0",
            color8: "#7A8FD4",
            color9: "#5FA8A0",
            color10: "#F3FAFC",
            color11: "#E2EEF3",
            color12: "#4FB6C6"
        },

        // =========================================================
        // Drakula
        // =========================================================
        "dark-drakula": {
            base: "#0F0F14",
            surface: "#121212",
            text: "#BD93F9",
            color1: "#0E0E0E",
            color2: "#6E7278",
            color3: "#9AA0A6",
            color4: "#CF6679",
            color5: "#E2C08D",
            color6: "#81C995",
            color7: "#8AB4F8",
            color8: "#22D3EE",
            color9: "#C3B1E1",
            color10: "#121212",
            color11: "#1E1E1E",
            color12: "#BD93F9"
        },

        "light-drakula": {
            base: "#F6F6FB",
            surface: "#F6F6FB",
            text: "#BD93F9C",
            color1: "#EEEFF6",
            color2: "#DDDEE7",
            color3: "#CCCCF0",
            color4: "#D95C5C",
            color5: "#E0D561",
            color6: "#4FAE6E",
            color7: "#4FAE6E",
            color8: "#8BE9FD",
            color9: "#FF79C6",
            color10: "#F6F6FB",
            color11: "#E8E8F2",
            color12: "#BD93F9"
        },

        // =========================================================
        // Normal
        // =========================================================
        "dark": {
            base: "#121212",
            surface: "#121212",
            text: "#8AB4F8",
            color1: "#161616",
            color2: "#6E7278",
            color3: "#9AA0A6",
            color4: "#CF6679",
            color5: "#E2C08D",
            color6: "#81C995",
            color7: "#8AB4F8",
            color8: "#22D3EE",
            color9: "#AEC6CF",
            color10: "#121212",
            color11: "#1E1E1E",
            color12: "#8AB4F8"
        },

        "light": {
            base: "#F7F8FA",
            surface: "#F7F8FA",
            text: "#4C8EDA",
            color1: "#EDEFF2",
            color2: "#AEB2B8",
            color3: "#C4C7CC",
            color4: "#D95C5C",
            color5: "#E0AF68",
            color6: "#4FAE6E",
            color7: "#4C8EDA",
            color8: "#5FA8A0",
            color9: "#B39DDB",
            color10: "#F7F8FA",
            color11: "#F2F4F7",
            color12: "#4C8EDA"
        },

        "default": {
            base:    "#191724",
            surface: "#1f1d2e",
            text:    "#e0def4",
            color1:  "#26233a",
            color2:  "#6e6a86",
            color3:  "#908caa",
            color4:  "#eb6f92",
            color5:  "#f6c177",
            color6:  "#ebbcba",
            color7:  "#31748f",
            color8:  "#9ccfd8",
            color9:  "#c4a7e7",
            color10: "#21202e",
            color11: "#403d52",
            color12: "#423f53"
        },
    }
}
