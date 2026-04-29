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



# --- Color Variables (Backgrounds) ---
BG_PURP="\e[48;5;54m"      # Deep Purple Sky
BG_PINK="\e[48;5;163m"     # Pink Horizon
BG_SUN="\e[48;5;226m\e[38;5;232m" # Yellow Bulb (Black text)

# --- Color Variables (Foregrounds) ---
FG_BLK="\e[30m"            # Solid Black for Silhouettes
FG_WHT="\e[97m"            # White for highlights
RESET="\e[0m"

# Clear the screen for the "Full Screen" effect
clear

echo -e "${BG_PURP}                                                  ${RESET}"
echo -e "${BG_PURP}   ${FG_BLK}▓▓▓▓             ▓▓▓▓▓▓          ▓▓       ${RESET}"
echo -e "${BG_PURP}   ${FG_BLK}▓▓▓▓   ▓▓▓▓      ▓▓▓▓▓▓   ▓▓▓    ▓▓       ${RESET}"
echo -e "${BG_PINK}   ${FG_BLK}▓▓▓▓   ▓▓▓▓      ▓▓▓▓▓▓   ▓▓▓    ▓▓       ${RESET}"
echo -e "${BG_PINK}                                                  ${RESET}"
echo -e "${BG_PINK}           ${FG_BLK}      _,,_      ${BG_PINK}                    ${RESET}"
echo -e "${BG_PINK}    ${FG_BLK} _,,,        /    \\       ,,,      ${BG_PINK}        ${RESET}"
echo -e "${BG_PINK}    ${FG_BLK}(_    '';   /| 00 |\\     (   ''';   ${BG_PINK}        ${RESET}"
echo -e "${BG_PINK}      ${FG_BLK}'';_   ';  \\_^__^/      )  _..';  ${BG_PINK}        ${RESET}"
echo -e "${BG_PINK}  ${FG_BLK}________';_    [[[  ]]]      ;';      ${BG_PINK}        ${RESET}"
echo -e "${BG_PINK}  ${FG_BLK}~~~~~~~~~~~'   [[[  ]]]     / /       ${BG_PINK}        ${RESET}"
echo -e "${BG_PINK} ${FG_BLK}══╦══════╦══════╦══█══╦══════╦══█══╦══════╦══ ${RESET}"
echo -e "${BG_PINK}   ${FG_BLK}║      ║      ║  █  ║      ║  █  ║      ║   ${RESET}"
echo -e "${BG_PINK}   ${FG_BLK}║      ║      ║  █  ${BG_SUN}  .  ${BG_PINK}  ║  █  ║      ║   ${RESET}"
echo -e "${BG_PINK}   ${FG_BLK}║      ║      ║  █ ${BG_SUN} ( ) ${BG_PINK} ║  █  ║      ║   ${RESET}"
echo -e "${BG_PINK}   ${FG_BLK}║      ║      ║  █  ${BG_SUN}  '  ${BG_PINK}  ║  █  ║      ║   ${RESET}"
echo -e "${BG_PINK} ${FG_BLK}══╩══════╩══════╩══█══╩══════╩══█══╩══════╩══ ${RESET}"
echo -e "${FG_BLK}▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ${RESET}"

echo -e "\n   ${FG_WHT}\"You only have one shot, Niko.\"${RESET}"

## Author

viewerofall
