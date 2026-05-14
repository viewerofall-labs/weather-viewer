import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "uptimeBar"

    StyledText {
        width: parent.width
        text: "Uptime Bar"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
        bottomPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "Displays how long your system has been running since the last boot."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        bottomPadding: Theme.spacingL
    }

    ToggleSetting {
        settingKey: "showSeconds"
        label: "Show seconds"
        description: "When off, time stops at hours and minutes (e.g. 1d 02:30)."
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showDays"
        label: "Show days"
        description: "When on, uptime uses a day prefix after 24h (e.g. 1d 02:30). When off, hours count up from boot (e.g. 26:30)."
        defaultValue: true
    }

    SliderSetting {
        settingKey: "barLeadingSpace"
        label: "Shift right"
        description: "Optional pixels before the icon. Default is 0 for a tight fit; increase only if a left neighbor overlaps."
        defaultValue: 0
        minimum: 0
        maximum: 64
        unit: "px"
    }

    StyledText {
        width: parent.width
        text: "Examples: with days 1d 02:30:45; without days 26:30:45; hide seconds 1d 02:30."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        topPadding: Theme.spacingL
    }
}
