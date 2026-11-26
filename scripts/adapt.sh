#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob

HOME_ESCAPED="$(printf '%s' "$HOME" | sed 's/[\\&|]/\\&/g')"

FILES=(
    "$HOME/.config/fastfetch/"*.jsonc
    "$HOME/.config/qt6ct/qt6ct.conf"
)

for file in "${FILES[@]}"; do
    [[ -f "$file" && ! -L "$file" ]] || continue

    if grep -q '__ECLIPSE_HOME__' "$file"; then
        sed -i "s|__ECLIPSE_HOME__|$HOME_ESCAPED|g" "$file"
        printf '[ADAPTED] %s\n' "$file"
    fi
done
