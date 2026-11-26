#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%Y-%m-%d_%H-%M-%S)"
SRC="$ROOT/system/greetd"
DEST="/var/backups/eclipse/greetd-$STAMP"

PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
RESET='\033[0m'

printf "${PINK}ECLIPSE // LOGIN INSTALLER${RESET}\n\n"

for cmd in greetd tuigreet uwsm; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[MISSING] $cmd"
        exit 1
    fi
done

for file in config.toml eclipse.sh; do
    if [[ ! -f "$SRC/$file" ]]; then
        echo "[MISSING] $file"
        exit 1
    fi
done

bash -n "$SRC/eclipse.sh"

echo "This module modifies /etc/greetd."
echo "A system backup will be created."
echo "The login service will NOT be restarted."
echo

read -rp "Install ECLIPSE Login? [y/N]: " confirm

[[ "$confirm" == "y" || "$confirm" == "Y" ]] || exit 0

sudo -v

sudo mkdir -p "$DEST"
sudo chmod 700 "$DEST"
sudo cp -a /etc/greetd/. "$DEST/"

echo "[OK] System backup created"

sudo install -m 755 "$SRC/eclipse.sh" /etc/greetd/eclipse.sh
sudo install -m 644 "$SRC/config.toml" /etc/greetd/config.toml

echo "[OK] Login script"
echo "[OK] Greetd configuration"

printf "\n${PURPLE}LOGIN INSTALLATION COMPLETE${RESET}\n"

printf 'Backup: %s\n' "$DEST"

echo
echo "Emergency rollback from TTY:"
printf 'sudo cp -a %q/. /etc/greetd/\n' "$DEST"

echo
echo "No services were restarted."
