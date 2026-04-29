# File Viewer Plugin

A lightweight file preview plugin for DankMaterialShell with fuzzy search, markdown rendering, and syntax highlighting for code files.

## Features

- **Multi-format Support**: View markdown, code files, and text files
- **Fuzzy Search**: Quickly find files with partial name/path matching
- **Markdown Rendering**: Display markdown with proper formatting:
  - Headings (multiple levels)
  - Bold and italic text
  - Code blocks
  - Lists (ordered and unordered)
  - Blockquotes with accent bar
  - Horizontal rules
- **Code Highlighting**: Syntax highlighting for code and config files (.js, .py, .json, .yaml, etc.)
- **Recent Files**: Quick access to recently viewed files
- **Configurable Settings**:
  - Text size (small/medium/large)
  - Preview theme (dark/light)
  - Line numbers toggle
  - Syntax highlighting toggle
  - Recent files count

## Installation

1. Copy the plugin folder to `~/.config/DankMaterialShell/plugins/markdownViewer/`
2. Restart DMS: `systemctl --user restart dms`
3. Trigger with `Ctrl+K \ ` in the launcher

## Usage

### Keyboard Shortcuts

- `Ctrl+K \ ` - Open file search
- `↑/↓` - Navigate search results
- `Enter` - Open selected file
- `Esc` - Close preview window

### Search

- Type filename or path to search home directory
- Results show file name and full path
- Recently viewed files appear at top of empty search
- Supports any file type (markdown, code, text, config, etc.)

## Configuration

Access via DMS plugins menu:
- **Text Size**: Adjust preview font size
- **Preview Theme**: Dark or light mode
- **Show Line Numbers**: Display line numbers in code blocks
- **Syntax Highlighting**: Enable code highlighting
- **Preview Lines**: Number of lines shown in search results
- **Recent Files Count**: How many recent files to remember

## Files

- `MarkdownLauncher.qml` - Main launcher interface
- `MarkdownPreview.qml` - Formatted preview window
- `MarkdownRenderer.qml` - QML rendering components (future)
- `markdown-parser.js` - Markdown parsing and file search
- `MarkdownSettings.qml` - Plugin configuration
- `plugin.json` - Plugin manifest
- `README.md` - This file

## Requirements

- DankMaterialShell >= 0.1.18
- Quickshell

## Future Enhancements

- Wiki-link support (`[[Note]]` syntax)
- Search within file content
- Backlinks panel
- Copy code block button
- Markdown editing mode
- Custom CSS themes
- Multi-file tabs

## Author

viewerofall
