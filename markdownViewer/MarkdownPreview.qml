import QtQuick
import Quickshell
import qs.Common
import "markdown-parser.js" as FileParser

Rectangle {
    id: root

    property string filePath: ""
    property string textSize: "medium"
    property string theme: "dark"
    property bool showLineNumbers: true
    property bool syntaxHighlight: true

    property string fileContent: ""
    property var parsedContent: []
    property string fileType: "text"

    color: theme === "dark" ? Theme.surface : "#fafafa"

    readonly property int baseFontSize: {
        if (textSize === "small") return 11
        if (textSize === "large") return 15
        return 13
    }

    onFilePathChanged: {
        if (filePath !== "") {
            fileType = FileParser.detectFileType(filePath)
            fileContent = FileParser.readFile(filePath)

            if (fileType === "markdown") {
                parsedContent = FileParser.parseMarkdown(fileContent)
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Row {
            width: parent.width
            spacing: 12

            Column {
                spacing: 2

                Text {
                    text: FileParser.getFileName(root.filePath)
                    font.bold: true
                    font.pixelSize: root.baseFontSize + 3
                    color: Theme.onSurface
                }

                Text {
                    text: root.filePath
                    color: Theme.onSurfaceVariant
                    font.pixelSize: root.baseFontSize - 2
                    font.family: "monospace"
                }
            }

            Item { width: 1; height: 1 }

            Button {
                text: "×"
                width: 40
                height: 40
                onClicked: root.parent.visible = false
            }
        }

        Loader {
            width: parent.width
            height: parent.height - 80
            sourceComponent: {
                if (root.fileType === "markdown") return markdownComponent
                return codeComponent
            }

            Component {
                id: markdownComponent
                ScrollView {
                    clip: true
                    Column {
                        width: parent.width
                        spacing: 8

                        Repeater {
                            model: root.parsedContent
                            delegate: Loader {
                                width: parent.width
                                sourceComponent: {
                                    switch(modelData.type) {
                                        case "heading": return headingComp
                                        case "paragraph": return paraComp
                                        case "code": return codeBlockComp
                                        case "list": return listComp
                                        case "blockquote": return blockquoteComp
                                        case "hr": return hrComp
                                        default: return paraComp
                                    }
                                }

                                Component {
                                    id: headingComp
                                    Text {
                                        width: parent.width
                                        text: modelData.content
                                        font.bold: true
                                        font.pixelSize: root.baseFontSize + (6 - modelData.level) * 2
                                        color: Theme.primary
                                        wrapMode: Text.WordWrap
                                        topPadding: modelData.level === 1 ? 8 : 4
                                        bottomPadding: 4
                                    }
                                }

                                Component {
                                    id: paraComp
                                    Text {
                                        width: parent.width
                                        text: modelData.content
                                        font.pixelSize: root.baseFontSize
                                        color: Theme.onSurface
                                        wrapMode: Text.WordWrap
                                        lineHeight: 1.4
                                    }
                                }

                                Component {
                                    id: codeBlockComp
                                    Rectangle {
                                        width: parent.width
                                        color: Theme.surfaceContainer
                                        radius: 4
                                        border.color: Theme.outline
                                        border.width: 1
                                        height: codeBlockText.implicitHeight + 12

                                        Text {
                                            id: codeBlockText
                                            anchors.fill: parent
                                            anchors.margins: 6
                                            text: modelData.content
                                            font.family: "monospace"
                                            font.pixelSize: root.baseFontSize - 1
                                            color: Theme.onSurface
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }

                                Component {
                                    id: listComp
                                    Column {
                                        width: parent.width
                                        spacing: 2
                                        Repeater {
                                            model: modelData.items
                                            Text {
                                                text: "• " + modelData
                                                font.pixelSize: root.baseFontSize
                                                color: Theme.onSurface
                                                wrapMode: Text.WordWrap
                                                width: parent.width
                                            }
                                        }
                                    }
                                }

                                Component {
                                    id: blockquoteComp
                                    Rectangle {
                                        width: parent.width
                                        color: Theme.surfaceContainer
                                        radius: 4
                                        height: blockquoteText.implicitHeight + 12

                                        Rectangle {
                                            width: 4
                                            height: parent.height
                                            color: Theme.primary
                                            radius: 2
                                        }

                                        Text {
                                            id: blockquoteText
                                            anchors.left: parent.left
                                            anchors.leftMargin: 12
                                            anchors.right: parent.right
                                            anchors.rightMargin: 8
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: modelData.content
                                            font.italic: true
                                            font.pixelSize: root.baseFontSize
                                            color: Theme.onSurfaceVariant
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }

                                Component {
                                    id: hrComp
                                    Rectangle {
                                        width: parent.width
                                        height: 1
                                        color: Theme.outline
                                        topPadding: 8
                                        bottomPadding: 8
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Component {
                id: codeComponent
                ScrollView {
                    clip: true
                    TextEdit {
                        width: parent.width
                        text: root.fileContent
                        font.family: "monospace"
                        font.pixelSize: root.baseFontSize
                        color: Theme.onSurface
                        readOnly: true
                        wrapMode: TextEdit.Wrap
                        selectByMouse: true
                    }
                }
            }
        }
    }

    Keys.onEscapePressed: root.parent.visible = false
}
