#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
RESET='\033[0m'

printf "${PINK}ECLIPSE // FULL INSTALLATION${RESET}\n\n"

for cmd in Hyprland hyprctl noctalia kitty \
           fish starship uwsm pacman; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[MISSING] $cmd"
        exit 1
    fi
done

shopt -s nullglob dotglob

ITEMS=(
    "$ROOT/dotfiles/.config/"*
    "$ROOT/dotfiles/.local/share/"*
    "$ROOT/dotfiles/.icons"
)

echo "Installation plan:"
echo

for item in "${ITEMS[@]}"; do
    [[ -e "$item" || -L "$item" ]] || continue
    printf ' - %s\n' "${item#"$ROOT/dotfiles/"}"
done

echo
echo "Existing configurations may be overwritten."
echo "A safety backup will be created."
echo

read -rp "Install ECLIPSE? [y/N]: " confirm

[[ "$confirm" == "y" || "$confirm" == "Y" ]] || exit 0

bash "$ROOT/scripts/backup.sh"

echo
echo "INSTALLING COMPONENTS"
echo "----------------------------------------"

for item in "${ITEMS[@]}"; do
    [[ -e "$item" || -L "$item" ]] || continue

    rel="${item#"$ROOT/dotfiles/"}"
    dest="$HOME/$rel"

    if [[ -L "$dest" ]]; then
        printf '[SKIP SYMLINK] %s\n' "$rel"
        continue
    fi

    mkdir -p "$(dirname "$dest")"
    cp -aT "$item" "$dest"

    printf '[OK] %s\n' "$rel"
done

echo
bash "$ROOT/scripts/adapt.sh" 
echo "INSTALLING WALLPAPERS"
echo "----------------------------------------"

if [[ -d "$ROOT/assets/wallpapers" ]]; then
    mkdir -p "$HOME/Pictures/ECLIPSE"
    cp -a "$ROOT/assets/wallpapers/." "$HOME/Pictures/ECLIPSE/"
    echo "[OK] Wallpapers"
fi

echo
read -rp "Install ECLIPSE Login as well? [y/N]: " login

if [[ "$login" == "y" || "$login" == "Y" ]]; then
    bash "$ROOT/scripts/login.sh"
fi

printf "\n${PURPLE}ECLIPSE INSTALLATION COMPLETE${RESET}\n"

echo
echo "Welcome to ECLIPSE."
echo "Review monitor and wallpaper paths before logging out."
echo "No automatic reboot will be performed."
