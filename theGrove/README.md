# 🌱 theGrove

> A living tree on your desktop that grows as long as DankMaterialShell does.

![DMS](https://img.shields.io/badge/DMS-%3E%3D1.2.0-5c7a5e?style=flat-square)
![Type](https://img.shields.io/badge/type-desktop%20widget-8bbf8a?style=flat-square)
![Author](https://img.shields.io/badge/author-viewerofall-27342c?style=flat-square)

---

## What is it

theGrove is a passive ambient desktop widget for [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell). It plants a tree on your desktop background layer that silently grows based on real elapsed time — no gamification, no streaks, no punishment. Just a tree that's been there as long as you have.

It also gets thirsty. Water it by clicking it.

---

## Features

- **Passive growth** — six stages driven by real calendar time since first launch, persisted across reboots and DMS restarts
- **Watering mechanic** — click the tree to water it; let it go too long and it wilts (subtly)
- **Watering countdown** — a "3h 20m until water" readout plus a thin depletion bar under the tree, so you know before it wilts, not after
- **Watering reminders** — native desktop notifications via `notify-send`, lands in your DMS notification center
- **Stage transition toasts** — notified when your tree levels up
- **Full theme integration** — reads `Theme.primary`, `Theme.surfaceContainer`, `Theme.surfaceText` from your active DMS theme; looks native on Deep Sage, Deep Mono, Deep Dark, Catppuccin, anything
- **Draggable and resizable** — standard DMS desktop widget controls; drag anywhere, resize via corner handles
- **Clickthrough toggle** — disable input if you just want ambient art
- **Zero external dependencies** — pure QML + JS, no extra packages

---

## Growth stages

| Days alive | Stage | Description |
|---|---|---|
| 0–2 | **Sprout** | Single stem, two tiny leaves |
| 3–6 | **Sapling** | Trunk emerging, four to six leaves, no branching |
| 7–13 | **Young Tree** | First branch fork, canopy starting |
| 14–29 | **Mature** | Full branching, dense canopy |
| 30–89 | **Ancient** | Wide trunk, visible root base, full crown |
| 90+ | **Elder** | Gnarled thick trunk, sprawling canopy |

Growth is time-based only. The tree cannot die. Neglecting to water it causes a temporary wilt visual; clicking it recovers it immediately.

---

## Watering

The tree tracks `lastWatered` separately from growth. If the configured watering interval passes without a click, the tree enters a **wilt state** — same growth stage, but leaf colors desaturate slightly and one or two leaves droop. It is subtle. You will notice.

Clicking the tree only does something if it's been at least the "Earliest watering" interval since the last click (default 4h) — otherwise it's a no-op with a small toast, so spam-clicking can't keep the countdown permanently full. Past that cooldown, clicking:
- Updates `lastWatered` and resets the countdown
- Plays a watering-can animation — it swoops in, tips over, and pours actual falling droplets onto the canopy, which gives a little perk/bounce as it lands (~1.3 seconds)
- Recovers wilt if active

A desktop notification fires when the tree has been unwatered past the threshold:

```
🌱 Grove — [treeName] is thirsty
```

A second notification fires on stage transitions:

```
🌳 Grove — [treeName] grew into an Ancient Tree!
```

Notification spam is guarded — a minimum cooldown between reminders prevents repeated fires on DMS restarts.

---

## Installation

```bash
git clone https://github.com/viewerofall/theGrove ~/.config/DankMaterialShell/plugins/theGrove
```

Then in DMS: **Settings → Plugins → Scan for Plugins → enable theGrove**.

---

## Settings

| Setting | Default | Description |
|---|---|---|
| Tree name | `"Grove"` | Flavor label shown on hover and in notifications |
| Watering interval | `24h` | How long before the tree wilts; 6h–72h range |
| Earliest watering | `4h` | Minimum time since last watering before a click does anything; 1h–24h range |
| Show day counter | `true` | Label below the widget showing days alive |
| Watering reminders | `true` | Enable notify-send notifications when thirsty |
| Widget opacity | `1.0` | Ghosted overlay support for wallpaper integration |
| Cheater mode | `false` | Override displayed growth stage (labeled as cheating) |
| Reset data | — | Button. Restarts the tree as a fresh sprout, right now, and clears wilt/notification history |

---

## State

Desktop widgets in DMS are always instances, so there's no separate state file — `firstLaunchDate`, `lastWatered`, `lastNotified`, and `currentStage` live alongside your settings in the widget instance's config (same store as the Settings table below, via `pluginService.loadPluginData`/`savePluginData`).

`firstLaunchDate` is written exactly once on first run and never touched again. Everything else updates normally.

---

## File structure

```
theGrove/
├── plugin.json        # manifest (type: desktop)
├── GroveWidget.qml     # desktop root — Timer, MouseArea, stage loader
├── GroveSettings.qml   # settings panel
├── stages/
│   ├── Sprout.qml
│   ├── Sapling.qml
│   ├── YoungTree.qml
│   ├── MatureTree.qml
│   ├── AncientTree.qml
│   └── ElderTree.qml  # gnarled elder, the endgame
└── grove.js            # pure logic: stage calc, hydration state, date math
```

`grove.js` has zero QML imports and is testable in isolation. All business logic lives there; QML files are presentation only.

---

## Theme compatibility

theGrove reads DMS theme variables at runtime — no hardcoded colors. It looks correct on any DMS theme out of the box.

Pairs especially well with [Deep Sage](https://github.com/viewerofall/dms-themes) where the tree renders in natural sage-toned bark and leaf colors via matugen.

---

## Requirements

- DankMaterialShell `>= 1.2.0` (desktop widget type + clickthrough option)
- `notify-send` available in `$PATH` (standard on any distro running a notification daemon; DMS handles this)

---

## License

MIT — see [LICENSE](./LICENSE)
