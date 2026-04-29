import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "markdownViewer"

    SelectionSetting {
        settingKey: "textSize"
        label: I18n.tr("Text Size")
        options: [
            { label: I18n.tr("Small"), value: "small" },
            { label: I18n.tr("Medium"), value: "medium" },
            { label: I18n.tr("Large"), value: "large" }
        ]
        defaultValue: "medium"
    }

    SelectionSetting {
        settingKey: "theme"
        label: I18n.tr("Preview Theme")
        options: [
            { label: I18n.tr("Dark"), value: "dark" },
            { label: I18n.tr("Light"), value: "light" }
        ]
        defaultValue: "dark"
    }

    ToggleSetting {
        settingKey: "showLineNumbers"
        label: I18n.tr("Show Line Numbers")
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "syntaxHighlight"
        label: I18n.tr("Syntax Highlighting")
        defaultValue: true
    }

    SliderSetting {
        settingKey: "maxPreviewLength"
        label: I18n.tr("Preview Lines in Search")
        defaultValue: 2
        minimum: 1
        maximum: 5
    }

    SliderSetting {
        settingKey: "recentFilesCount"
        label: I18n.tr("Recent Files Count")
        defaultValue: 5
        minimum: 1
        maximum: 20
    }
}
