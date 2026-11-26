#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y-%m-%d_%H-%M-%S)"
DEST="$ROOT/backups/$STAMP"

PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
RESET='\033[0m'

umask 077
mkdir -p "$ROOT/backups"
mkdir "$DEST"
mkdir -p "$DEST/home"

printf "${PINK}ECLIPSE // BACKUP MANAGER${RESET}\n\n"

shopt -s nullglob dotglob

ITEMS=(
    "$ROOT/dotfiles/.config/"*
    "$ROOT/dotfiles/.local/share/"*
    "$ROOT/dotfiles/.icons"
)

for item in "${ITEMS[@]}"; do
    rel="${item#"$ROOT/dotfiles/"}"
    src="$HOME/$rel"

    if [[ -e "$src" || -L "$src" ]]; then
        mkdir -p "$DEST/home/$(dirname "$rel")"
        cp -a "$src" "$DEST/home/$rel"
        printf '[OK] %s\n' "$rel"
    else
        printf '[SKIP] %s\n' "$rel"
    fi
done

pacman -Qqe > "$DEST/packages.txt"
pacman -Qqm > "$DEST/foreign.txt" || true

touch "$DEST/.complete"

printf "\n${PURPLE}BACKUP COMPLETE${RESET}\n"
printf 'Location: %s\n' "$DEST"
du -sh "$DEST"
