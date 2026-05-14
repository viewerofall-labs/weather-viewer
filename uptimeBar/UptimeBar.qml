import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root
    
    layerNamespacePlugin: "uptimeBar"

    property bool showSeconds: pluginData.showSeconds ?? true
    property bool showDays: pluginData.showDays ?? true
    property int barLeadingSpace: pluginData.barLeadingSpace ?? 0
    property string uptimeDisplay: "0:00"

    Process {
        id: uptimeProc
        command: ["/bin/cat", "/proc/uptime"]
        
        stdout: StdioCollector {
            id: stdout
            onStreamFinished: {
                if (text && text.trim().length > 0) {
                    try {
                        const uptimeSeconds = Math.floor(parseFloat(text.trim().split(" ")[0]))
                        
                        const days = Math.floor(uptimeSeconds / 86400)
                        const hoursInDay = Math.floor((uptimeSeconds % 86400) / 3600)
                        const totalHours = Math.floor(uptimeSeconds / 3600)
                        const minutes = Math.floor((uptimeSeconds % 3600) / 60)
                        const seconds = uptimeSeconds % 60

                        let timeStr = ""
                        if (root.showDays && days > 0) {
                            timeStr += days + "d "
                        }
                        const hourField = root.showDays ? hoursInDay : totalHours
                        timeStr += String(hourField).padStart(2, '0') + ":"
                        timeStr += String(minutes).padStart(2, '0')
                        if (root.showSeconds) {
                            timeStr += ":" + String(seconds).padStart(2, '0')
                        }
                        root.uptimeDisplay = timeStr
                    } catch (e) {
                        console.error("Parse error:", e)
                    }
                }
            }
        }

        stderr: StdioCollector {}
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (!uptimeProc.running) {
                uptimeProc.running = true
            }
        }
    }

    Component.onCompleted: {
        uptimeProc.running = true
    }

    // Shrink-wrapped Item so the bar slot is only icon + text (+ optional leading inset), no extra dead width.
    horizontalBarPill: Component {
        Item {
            implicitWidth: barRow.implicitWidth
            implicitHeight: barRow.implicitHeight
            width: implicitWidth
            height: implicitHeight

            Row {
                id: barRow
                spacing: (root.barConfig?.noBackground ?? false) ? 2 : Theme.spacingXXS

                Item {
                    width: root.barLeadingSpace
                    height: Math.max(1, root.barThickness || 1)
                }

                DankIcon {
                    name: "schedule"
                    size: Theme.barIconSize(root.barThickness, -4)
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: root.uptimeDisplay
                    font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale)
                    font.family: "monospace"
                    font.weight: Font.Medium
                    color: Theme.widgetTextColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
