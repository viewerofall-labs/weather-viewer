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

    function getListerBinary() {
        return "/home/abyss/.config/DankMaterialShell/plugins/markdownViewer/bin/dms-lister-amd64"
    }

    function listDirectory(dirPath) {
        let tempFile = "/tmp/dms_list_" + Math.random().toString(36).substring(7) + ".json"
        let binary = getListerBinary()
        let escapedPath = dirPath.replace(/'/g, "'\\''")
        let cmd = "'" + binary + "' '" + escapedPath + "' > " + tempFile + " 2>/dev/null"

        // Execute synchronously-ish with sleep to ensure completion
        Quickshell.execDetached(["sh", "-c", cmd + " && sleep 0.2"])

        // Give it time to complete
        let start = Date.now()
        while (Date.now() - start < 300) {
            // Busy wait - not ideal but ensures data is ready
        }

        // Read the result
        try {
            let xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + tempFile, false)
            xhr.send()

            if (xhr.status === 200 && xhr.responseText) {
                let data = JSON.parse(xhr.responseText)
                if (data.files) {
                    return data.files
                }
            }
        } catch (e) {
            console.warn("Error listing " + dirPath + ": " + e)
        }

        return []
    }

    function getItems(query) {
        let items = []
        let cleanQuery = (query || "").trim()

        while (cleanQuery.startsWith("\\")) {
            cleanQuery = cleanQuery.substring(1).trim()
        }

        if (!cleanQuery || cleanQuery.length === 0) {
            // List home directory
            let files = listDirectory(homeDir)
            if (files.length > 0) {
                items = files.map(f => ({
                    name: f.name,
                    icon: f.isDir ? "material:folder" : "material:description",
                    comment: f.path,
                    action: "open:" + f.path,
                    categories: ["FileViewer"]
                }))
            } else {
                items = [{
                    name: "Home directory empty",
                    icon: "material:folder",
                    comment: homeDir,
                    action: "noop:",
                    categories: ["FileViewer"]
                }]
            }

        } else if (cleanQuery.includes("/")) {
            // Directory path
            let expandedPath = expandPath(cleanQuery)
            let files = listDirectory(expandedPath)

            if (files.length > 0) {
                items = files.map(f => ({
                    name: f.name,
                    icon: f.isDir ? "material:folder" : "material:description",
                    comment: f.path,
                    action: "open:" + f.path,
                    categories: ["FileViewer"]
                }))
            } else {
                items = [{
                    name: expandedPath + " not found or empty",
                    icon: "material:folder",
                    comment: expandedPath,
                    action: "noop:",
                    categories: ["FileViewer"]
                }]
            }

        } else {
            // Search mode - filter home directory
            let files = listDirectory(homeDir)
            let searchTerm = cleanQuery.toLowerCase()

            if (files.length > 0) {
                let results = files.filter(f => f.name.toLowerCase().includes(searchTerm))
                if (results.length > 0) {
                    items = results.map(f => ({
                        name: f.name,
                        icon: f.isDir ? "material:folder" : "material:description",
                        comment: f.path,
                        action: "open:" + f.path,
                        categories: ["FileViewer"]
                    }))
                } else {
                    items = [{
                        name: 'No matches for "' + cleanQuery + '"',
                        icon: "material:search",
                        comment: "Try another search",
                        action: "noop:",
                        categories: ["FileViewer"]
                    }]
                }
            } else {
                items = [{
                    name: "Home directory empty",
                    icon: "material:folder",
                    comment: homeDir,
                    action: "noop:",
                    categories: ["FileViewer"]
                }]
            }
        }

        return items
    }

    function executeItem(item) {
        if (!item || !item.action) return

        let action = item.action
        if (action.startsWith("open:")) {
            let filePath = action.substring(5)
            if (filePath && filePath.length > 0) {
                Quickshell.execDetached(["xdg-open", filePath])
            }
        }
    }
}
