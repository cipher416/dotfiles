# Hanabi Dotfiles

A monochrome, Vercel-inspired Hyprland desktop for Manjaro/Arch Linux. The setup keeps KDE and SDDM available as a fallback and launches Hyprland through UWSM.

## Included

- Hyprland 0.55 Lua configuration, Hyprpaper, Hyprlock, and Hypridle
- Waybar with workspaces, MPRIS, CAVA audio visualization, Codex quota status, telemetry, tray, and service-backed visibility toggle
- Fuzzel launcher, Mako notifications, and Btop theme
- Vicinae settings and the custom `vercel-noir` theme
- Audio output, Bluetooth, and monitor-brightness pickers, screenshot, system menu, clipboard, and keybinding helper scripts
- The active wallpaper and the SDDM UWSM session entry

Runtime databases, caches, extension downloads, credentials, and obsolete Vicinae configuration are intentionally excluded.

## Install

On an Arch-based system with `git` and an AUR helper:

```bash
git clone https://github.com/cipher416/dotfiles.git ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
./install.sh --packages
```

Run `./install.sh` without `--packages` to restore only the tracked files. Pass `--home-only` to skip the system session entry and Waybar service. Existing files that differ are copied to `~/.local/state/dotfiles-backups/<timestamp>` before replacement.

The package install expects `yay` for AUR packages. The AUR manifest supplies Apple fonts, the macOS XCursor and Hyprcursor themes, Vicinae, and Zen Browser. SF Pro and SF Mono are Apple fonts; review their license before redistribution.

After installation, log out and select **Hyprland (uwsm-managed)** in SDDM. Waybar is enabled as a systemd user service and starts only in a supported Wayland compositor session.

## Machine-Specific Settings

`home/.config/hypr/hyprland.lua` preserves this workstation's monitor topology:

- `HDMI-A-2` at `0x0`, highest refresh rate
- `DP-5` at `1920x0`, preferred mode
- A generic fallback for any other display

Adjust those monitor blocks before installing on different hardware. The config assumes `ghostty`, `dolphin`, Zen Browser, Zed, Cursor, and Lazydocker for application shortcuts.

## Keybindings

| Binding | Action |
| --- | --- |
| `Super + Space` | Vicinae |
| `Super + R` | Fuzzel |
| `Super + Return` | Terminal |
| `Super + W` | Close window |
| `Super + F` | Fullscreen |
| `Super + Alt + F` | Maximize |
| `Super + Shift + S` | Region screenshot |
| `Super + Shift + Space` | Toggle or recover Waybar |
| `Super + Ctrl + L` | Lock |
| `Super + K` | Search all keybindings |

## Updating The Snapshot

The live files remain normal files rather than symlinks. After changing them, commit any current repository work and run:

```bash
./sync.sh
git diff
```

`sync.sh` refuses to overwrite a dirty repository. Review the resulting diff before committing and pushing.
