#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ -n "$(git -C "$repo_root" status --porcelain)" ]]; then
  printf 'Refusing to sync into a dirty repository. Commit or stash existing changes first.\n' >&2
  exit 1
fi

tracked_paths=(
  .config/hypr
  .config/waybar
  .config/fuzzel
  .config/mako
  .config/btop
  .config/cava/waybar.conf
  .config/vicinae/settings.json
  .local/bin/hypr-menu
  .local/bin/hypr-audio-output
  .local/bin/hypr-bluetooth
  .local/bin/hypr-monitor-brightness
  .local/bin/hypr-screenshot
  .local/bin/hypr-waybar-toggle
  .local/bin/waybar-cava
  .local/share/vicinae/themes/vercel-noir.toml
)

for relative in "${tracked_paths[@]}"; do
  source="$HOME/$relative"
  destination="$repo_root/home/$relative"

  if [[ ! -e "$source" ]]; then
    printf 'Missing tracked path: %s\n' "$source" >&2
    exit 1
  fi

  rm -rf -- "$destination"
  mkdir -p "$(dirname -- "$destination")"
  cp -a -- "$source" "$destination"
done

cp -a -- /usr/local/share/wayland-sessions/hyprland-uwsm.desktop \
  "$repo_root/system/usr/local/share/wayland-sessions/hyprland-uwsm.desktop"

printf 'Snapshot updated. Review with: git -C %q diff\n' "$repo_root"
