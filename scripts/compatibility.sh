#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
GREEN='\033[38;2;134;217;160m'
RESET='\033[0m'

printf "${PINK}ECLIPSE // COMPATIBILITY CHECK${RESET}\n\n"

echo "SYSTEM INFORMATION"
echo "----------------------------------------"

grep '^PRETTY_NAME=' /etc/os-release
printf 'Kernel: %s\n' "$(uname -r)"
printf 'Architecture: %s\n' "$(uname -m)"
printf 'Session: %s\n' "${XDG_SESSION_TYPE:-unknown}"

echo
echo "REQUIRED COMPONENTS"
echo "----------------------------------------"

MISSING=0

for cmd in Hyprland hyprctl noctalia kitty fastfetch \
           starship fish kvantummanager qt6ct \
           uwsm pacman; do

    if command -v "$cmd" >/dev/null 2>&1; then
        printf "${GREEN}[OK]${RESET} %s\n" "$cmd"
    else
        printf "${PINK}[MISSING]${RESET} %s\n" "$cmd"
        MISSING=$((MISSING+1))
    fi
done

echo
echo "OPTIONAL COMPONENTS"
echo "----------------------------------------"

for cmd in tuigreet greetd dolphin nwg-look \
           plymouth grub-mkconfig; do

    if command -v "$cmd" >/dev/null 2>&1; then
        printf "${GREEN}[OK]${RESET} %s\n" "$cmd"
    else
        printf "[NOT FOUND] %s\n" "$cmd"
    fi
done

echo
echo "PROJECT FILES"
echo "----------------------------------------"

for item in dotfiles assets packages system scripts; do
    if [[ -d "$ROOT/$item" ]]; then
        printf "${GREEN}[OK]${RESET} %s\n" "$item"
    else
        printf "${PINK}[MISSING]${RESET} %s\n" "$item"
        MISSING=$((MISSING+1))
    fi
done

echo
echo "DISK SPACE"
df -h "$HOME"

echo
printf "${PURPLE}CHECK COMPLETE${RESET}\n"
printf 'Missing required items: %s\n' "$MISSING"

if (( MISSING == 0 )); then
    echo "Basic requirements satisfied."
else
    echo "Review missing components before installation."
fi
