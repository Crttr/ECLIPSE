#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
RESET='\033[0m'

printf "${PINK}ECLIPSE // RESTORE MANAGER${RESET}\n\n"

shopt -s nullglob dotglob

BACKUPS=()

for dir in "$ROOT/backups/"*; do
    if [[ -d "$dir/home" && -f "$dir/.complete" ]]; then
        BACKUPS+=("$dir")
    fi
done

if [[ ${#BACKUPS[@]} -eq 0 ]]; then
    echo "No completed backups found."
    exit 0
fi

for i in "${!BACKUPS[@]}"; do
    printf '[%s] %s\n' "$((i+1))" "$(basename "${BACKUPS[$i]}")"
done

printf '[0] Cancel\n\n'
read -rp "Select backup: " choice

[[ "$choice" == "0" ]] && exit 0

if [[ ! "$choice" =~ ^[1-9][0-9]*$ ]] ||
   (( ${#choice} > 6 )) ||
   (( choice > ${#BACKUPS[@]} )); then
    echo "Invalid selection."
    exit 1
fi

SRC="${BACKUPS[$((choice-1))]}/home"

printf "\nSelected: %s\n" "$SRC"
printf "Existing configuration files may be overwritten.\n"

read -rp "Continue? [y/N]: " confirm
[[ "$confirm" == "y" || "$confirm" == "Y" ]] || exit 0

echo "Creating safety backup..."
bash "$ROOT/scripts/backup.sh"

ITEMS=(
    "$SRC/.config/"*
    "$SRC/.local/share/"*
    "$SRC/.icons"
)

for item in "${ITEMS[@]}"; do
    [[ -e "$item" || -L "$item" ]] || continue

    rel="${item#"$SRC/"}"
    dest="$HOME/$rel"

    mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" ]]; then
        printf '[SKIP SYMLINK] %s\n' "$rel"
        continue
    fi

    cp -aT "$item" "$dest"
    printf '[OK] %s\n' "$rel"
done

printf "\n${PURPLE}RESTORE COMPLETE${RESET}\n"
echo "Log out and log in to apply changes."
