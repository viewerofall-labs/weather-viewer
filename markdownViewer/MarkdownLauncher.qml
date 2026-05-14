import QtQuick
import Quickshell
import qs.Services

Item {
    id: root

    property var pluginService: null
    property string trigger: "\\"
    property string homeDir: ""

    signal itemsChanged()

    Component.onCompleted: {
        console.info("FileViewer: Plugin loaded")
        homeDir = getHomeDir()
    }

    function getHomeDir() {
        try {
            if (Qt.application && Qt.application.userHomeDirectory) {
                return Qt.application.userHomeDirectory
            }
        } catch (e) {}
        return "/home/abyss"
    }

    function expandPath(path) {
        if (path.startsWith("~")) {
            return path.replace("~", homeDir)
        }
        return path
    }

    function getFileListScript() {
        return expandPath("~/.config/DankMaterialShell/plugins/markdownViewer/dms-file-lister.py")
    }

    function runCommand(cmd) {
        let tempFile = "/tmp/dms_list_" + Math.random().toString(36).substring(7) + ".json"
        let fullCmd = cmd + " > " + tempFile + " 2>/dev/null"

        // Execute command
        Quickshell.execDetached(["sh", "-c", fullCmd + " && sleep 0.1"])

        // Wait for file to be written
        let start = Date.now()
        while (Date.now() - start < 500) {
            // Busy wait - ensures data is ready
        }

        // Read the result
        try {
            let xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + tempFile, false)
            xhr.send()

            if (xhr.status === 200 && xhr.responseText) {
                let data = JSON.parse(xhr.responseText)
                // Clean up temp file
                Quickshell.execDetached(["rm", "-f", tempFile])
                return data
            }
        } catch (e) {
            console.warn("Error reading result: " + e)
            Quickshell.execDetached(["rm", "-f", tempFile])
        }

        return { files: [], error: "unknown error" }
    }

    function listDirectory(dirPath) {
        let script = getFileListScript()
        let escapedPath = dirPath.replace(/'/g, "'\\''")
        let cmd = "python3 '" + script + "' list '" + escapedPath + "'"
        
        return runCommand(cmd)
    }

    function searchMarkdownFiles(dirPath, query) {
        let script = getFileListScript()
        let escapedPath = dirPath.replace(/'/g, "'\\''")
        let escapedQuery = (query || "").replace(/'/g, "'\\''")
        let cmd = "python3 '" + script + "' search '" + escapedPath + "' '" + escapedQuery + "'"
        
        return runCommand(cmd)
    }

    function readFile(filePath) {
        let script = getFileListScript()
        let escapedPath = filePath.replace(/'/g, "'\\''")
        let cmd = "python3 '" + script + "' read '" + escapedPath + "'"
        
        return runCommand(cmd)
    }

    function getItems(query) {
        let items = []
        let cleanQuery = (query || "").trim()

        while (cleanQuery.startsWith("\\")) {
            cleanQuery = cleanQuery.substring(1).trim()
        }

        // Determine search path
        let searchPaths = [
            expandPath("~/.scratchpad/notes"),
            expandPath("~/"),
            expandPath("~/repos")
        ]

        // Try each search path
        for (let i = 0; i < searchPaths.length; i++) {
            let result = searchMarkdownFiles(searchPaths[i], cleanQuery)
            
            if (result.files && result.files.length > 0) {
                for (let j = 0; j < Math.min(result.files.length, 10); j++) {
                    let file = result.files[j]
                    let preview = ""

                    // Try to get preview for markdown files
                    if (file.name.toLowerCase().endsWith('.md')) {
                        let readResult = readFile(file.path)
                        if (readResult.content) {
                            preview = readResult.content.split('\n')[0].substring(0, 80)
                        }
                    }

                    items.push({
                        id: "file_" + i + "_" + j,
                        name: file.name,
                        comment: (file.isDir ? "[DIR] " : "") + (preview ? preview : file.path),
                        icon: file.isDir ? "folder" : "description",
                        actions: [{
                            id: "open",
                            text: "Open",
                            callback: function() {
                                openFile(file.path)
                            }
                        }]
                    })
                }
                return items
            }
        }

        // If no results, list current directory
        let homeResult = listDirectory(expandPath("~/"))
        if (homeResult.files) {
            for (let i = 0; i < Math.min(homeResult.files.length, 10); i++) {
                let file = homeResult.files[i]
                items.push({
                    id: "file_" + i,
                    name: file.name,
                    comment: (file.isDir ? "[DIR] " : "") + file.path,
                    icon: file.isDir ? "folder" : "description",
                    actions: [{
                        id: "open",
                        text: "Open",
                        callback: function() {
                            openFile(file.path)
                        }
                    }]
                })
            }
        }

        return items
    }

    function openFile(filePath) {
        // Check if it's a markdown file
        if (filePath.toLowerCase().endsWith('.md')) {
            // Open in default text editor or viewer
            Quickshell.execDetached(["xdg-open", filePath])
        } else if (Qt.platform.os === "linux") {
            Quickshell.execDetached(["xdg-open", filePath])
        }
    }

    function executeItem(item) {
        if (item.actions && item.actions.length > 0) {
            item.actions[0].callback()
        }
    }
}
