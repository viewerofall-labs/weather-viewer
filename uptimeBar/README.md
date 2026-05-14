# Uptime Bar (DankMaterialShell)

Small dankbar widget: **schedule icon + monospace uptime**, sized with the same bar theming as other plugins (`Theme.barIconSize`, `Theme.barTextSize`, `barThickness` / `barConfig`). The root is **shrink-wrapped** so the slot is only as wide as the icon, spacing, text, and any optional left inset—no extra empty horizontal box.

## Features

- Reads **`/proc/uptime`** once per second (no `uptime` binary required).
- **Show seconds** — append `:ss` or stop at `HH:MM` (and day prefix when enabled).
- **Show days** — after 24h either `Nd HH:MM…` or, when off, total hours since boot (`26:30…`).
- **Shift right** — optional extra pixels before the icon if something to the left still crowds you.

## Display examples

| Setting        | Example        |
|----------------|----------------|
| Days + seconds | `1d 02:30:45`  |
| No days        | `26:30:45`     |
| No seconds     | `1d 02:30`     |

## Settings

Open **Settings → Plugins → Uptime Bar**.

- **Show seconds** — default on.
- **Show days** — default on (`Nd` prefix); off uses rolling hours.
- **Shift right** — default **0** px (tight layout); raise only if you need clearance from a left neighbor.

## Install / reload

Copy this folder under your DMS plugins directory, e.g. `~/.config/DankMaterialShell/plugins/uptimeBar`, then reload plugins from DMS (or restart the shell) so **`uptimeBar`** is picked up.

## Requirements

- DMS **>= 1.4.0** (see `plugin.json`).
- Linux with **`/proc/uptime`**.

## License

MIT
