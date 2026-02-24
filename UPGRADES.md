# UPGRADES

Focused, high‑leverage additions to level up speed, automation, and system control based on your workflow.

## Profile Summary
- Arch + Hyprland, speed‑first UX, keyboard‑only preference.
- Primary stack: Brave + JS/TS + self‑hosted services.
- Launcher is central to workflow; needs to be instant.
- Wants automation for email → todos/calendar and quick‑add actions.
- Single machine, local‑first where possible, minimal UI.

## Top Priorities (Highest Impact)

1. **System Control Actions via Launcher**
   - Goal: use your existing dmenu/fzf launcher as a keyboard control center.
   - Actions:
     - Wi‑Fi: list networks, connect, toggle Wi‑Fi (`nmcli`).
     - Bluetooth: list devices, connect/disconnect, toggle (`bluetoothctl`).
     - Audio: sink select + mute/unmute + volume (`wpctl`).
     - Power: lock, suspend, hibernate, reboot.
     - Display: brightness up/down (`brightnessctl`), nightlight (`hyprsunset`).
     - Screenshots: OCR shot, region capture, copy to clipboard.
   - Implementation: add a `dmenu-actions.sh` that outputs action labels → commands, reuse the same fzf flow.

2. **Clipboard History (Minimal, Fast)**
   - Tooling: `wl-clipboard` + `cliphist` + fzf.
   - UX: a small, pinned foot window (same style as launcher).
   - Bonus: actions for “copy as plain text”, “delete entry”, “clear history”.

3. **Terminal File Explorer (Speed‑First)**
   - Recommended: `yazi` (fast TUI, keyboard‑driven, minimal UI).
   - Alternative: `lf` (very fast, minimal, scriptable).
   - Hook into `open-foot.sh` so it can open at last dir.

4. **Quick‑Add for Todoist + Calendar**
   - Add launcher actions:
     - “Add Todoist task” (prompt → API quick add).
     - “Add calendar event” (Google now, Nextcloud later).
   - Future‑proof: keep provider in a tiny config file, so you can switch to Nextcloud.
   - Store secrets locally only (no repo secrets).

## Automation & Personal Assistant

1. **Local‑First “Inbox Summaries”**
   - Pipe email metadata into a local summarizer (Ollama).
   - Generate daily brief: actionable items + suggested todos.
   - First step: add a script that pulls headers from your mail server (IMAP).

2. **Email → Todoist Rules**
   - Simple initial approach: CLI that takes a URL + subject and creates a Todoist task.
   - Later: IMAP filter → script → Todoist quick add.

3. **Voice Input for Tasks**
   - Local: `whisper.cpp` or `whisper` via `whisper.cpp` bindings.
   - Flow: press hotkey → record → transcribe → quick add to Todoist or calendar.

## Self‑Hosting Quality of Life

1. **Service Health Snapshot**
   - Add a launcher action to show a one‑liner health summary (HTTP checks).
   - Optional: notify on failures via `mako`.

2. **Fast “Ops Console”**
   - A TUI that lists your most‑used services and common actions (restart, logs, status).
   - Backed by scripts calling `ssh`, `systemctl`, or your orchestration tools.

## Desktop/UX

1. **Waybar Migration (Minimal)**
   - Keep it sparse: workspace, time, battery, network, BT, audio.
   - Offload all actions to launcher to keep the bar minimal.

2. **One‑Key Focus Modes**
   - “Focus” profile toggles: notifications off, warmer display, low audio.
   - “Meeting” profile: mic enable, notifications low, DND on.

## Reliability & Maintenance

1. **Module Dependency Tracking**
   - Ensure each module declares its package dependencies (Nix or `yay` list).
   - Add a “check” command to report missing commands at runtime.

2. **Bootstrap Script**
   - A single entry point that:
     - sets up doas,
     - installs yay,
     - installs core modules,
     - runs Home Manager switch.

## Immediate Next Steps (Recommended Order)

1. Build `dmenu-actions.sh` (system controls + Todoist quick add).
2. Add `cliphist` + fzf clipboard picker.
3. Add `yazi` or `lf` as fast terminal file explorer.
4. Add local‑first voice task add (Whisper + Todoist quick add).

If you want, I can implement the first two (launcher actions + clipboard history) directly and keep everything ultra‑fast. You can then decide on file explorer + assistant workflows. 
