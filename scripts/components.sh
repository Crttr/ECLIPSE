#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
RESET='\033[0m'

install_items() {
    for rel in "$@"; do
        src="$ROOT/dotfiles/$rel"
        dest="$HOME/$rel"

        if [[ ! -e "$src" && ! -L "$src" ]]; then
            printf '[NOT FOUND] %s\n' "$rel"
            continue
        fi

        if [[ -L "$dest" ]]; then
            printf '[SKIP SYMLINK] %s\n' "$rel"
            continue
        fi

        mkdir -p "$(dirname "$dest")"
        cp -aT "$src" "$dest"
        printf '[OK] %s\n' "$rel"
    done
}

while true; do
    clear
    printf "${PINK}ECLIPSE // COMPONENT MANAGER${RESET}\n\n"

    echo "[1] Hyprland"
    echo "[2] Noctalia Shell"
    echo "[3] Terminal and Fish"
    echo "[4] Qt and Kvantum"
    echo "[5] GTK and Dolphin"
    echo "[6] Icons and Cursors"
    echo "[7] Fastfetch and Btop"
    echo "[0] Back"

    echo
    read -rp "Select component: " choice

    case "$choice" in
        1) ITEMS=(.config/hypr) ;;
        2) ITEMS=(.config/noctalia) ;;
        3) ITEMS=(.config/kitty .config/alacritty
                  .config/fish .config/starship.toml) ;;
        4) ITEMS=(.config/Kvantum .config/qt5ct
                  .config/qt6ct) ;;
        5) ITEMS=(.config/gtk-3.0 .config/gtk-4.0
                  .config/dolphinrc .config/kdeglobals
                  .local/share/color-schemes) ;;
        6) ITEMS=(.icons .local/share/icons) ;;
        7) ITEMS=(.config/fastfetch .config/btop) ;;
        0) exit 0 ;;
        *) continue ;;
    esac

    printf '\nSelected files:\n'
    printf ' - %s\n' "${ITEMS[@]}"
    bash "$ROOT/scripts/adapt.sh"

    read -rp "Install component? [y/N]: " confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        bash "$ROOT/scripts/backup.sh"
        install_items "${ITEMS[@]}"
        printf "\n${PURPLE}INSTALLATION COMPLETE${RESET}\n"
    else
        echo "Installation cancelled."
    fi

    read -rp "Press Enter to continue..."
done
