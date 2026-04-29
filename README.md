# deskweather

A collection of DankMaterialShell plugins for weather visualization and file management.

## Plugins

### Weather Art Widget
A responsive ASCII weather art widget with dynamic scenes, customizable stats, and theme support.

- **Status**: Stable
- **Features**: ASCII art scenes, background styles, stat customization, personality messages
- **Trigger**: Widget (add to desktop)
- **Location**: `/weatherArt`

[Weather Art README](./weatherArt/README.md)

### File Viewer (WIP)
A file preview launcher plugin with markdown rendering and syntax highlighting for code files.

- **Status**: Work in Progress
- **Features**: Directory listing, file search, markdown preview, code syntax highlighting
- **Trigger**: `\` (launcher)
- **Location**: `/markdownViewer`
- **Note**: Architecture review in progress. Awaiting finalization before registry submission.

[File Viewer README](./markdownViewer/README.md)

## Installation

Each plugin can be installed independently:

```bash
# Weather Art Widget
cp -r weatherArt ~/.config/DankMaterialShell/plugins/

# File Viewer (when stable)
cp -r markdownViewer ~/.config/DankMaterialShell/plugins/
```

Restart DMS: `systemctl --user restart dms`

## Documentation

- [Weather Art Widget](./weatherArt/README.md) — ASCII weather widget with customizable stats and themes
- [File Viewer](./markdownViewer/README.md) — File search and preview launcher (WIP)

## Author

viewerofall
