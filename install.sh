#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install_packages=false
home_only=false

usage() {
  printf 'Usage: %s [--packages] [--home-only]\n' "${0##*/}"
  printf '  --packages  Install the tracked pacman and AUR packages first.\n'
  printf '  --home-only Install user files without the system session or Waybar service.\n'
}

while (($#)); do
  case "$1" in
    --packages) install_packages=true ;;
    --home-only) home_only=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

read_packages() {
  local file="$1"
  while IFS= read -r package; do
    [[ -n "$package" && "$package" != \#* ]] && printf '%s\n' "$package"
  done < "$file"
}

if "$install_packages"; then
  mapfile -t pacman_packages < <(read_packages "$repo_root/packages/pacman.txt")
  sudo pacman -S --needed "${pacman_packages[@]}"

  if command -v yay >/dev/null 2>&1; then
    mapfile -t aur_packages < <(read_packages "$repo_root/packages/aur.txt")
    yay -S --needed "${aur_packages[@]}"
  else
    printf 'Skipping AUR packages because yay is not installed. See packages/aur.txt.\n' >&2
  fi
fi

backup_root="$HOME/.local/state/dotfiles-backups/$(date +'%Y%m%d-%H%M%S')"
backed_up=false

while IFS= read -r -d '' source; do
  relative="${source#"$repo_root/home/"}"
  destination="$HOME/$relative"

  if [[ -e "$destination" ]] && ! cmp -s "$source" "$destination"; then
    backup="$backup_root/$relative"
    mkdir -p "$(dirname -- "$backup")"
    cp -a -- "$destination" "$backup"
    backed_up=true
  fi

  mkdir -p "$(dirname -- "$destination")"
  cp -a -- "$source" "$destination"
done < <(find "$repo_root/home" -type f -print0)

if ! "$home_only"; then
  sudo install -Dm644 \
    "$repo_root/system/usr/local/share/wayland-sessions/hyprland-uwsm.desktop" \
    /usr/local/share/wayland-sessions/hyprland-uwsm.desktop

  systemctl --user enable waybar.service
  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    systemctl --user restart waybar.service
  fi
fi

if "$backed_up"; then
  printf 'Previous files were backed up to %s\n' "$backup_root"
fi
printf 'Dotfiles installed.\n'
if ! "$home_only"; then
  printf 'Select Hyprland (uwsm-managed) at login.\n'
fi
