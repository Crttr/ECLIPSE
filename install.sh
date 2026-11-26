#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PINK='\033[38;2;255;77;141m'
PURPLE='\033[38;2;168;85;247m'
WHITE='\033[38;2;221;213;226m'
GRAY='\033[38;2;120;120;140m'
RESET='\033[0m'

header() {
    clear

    printf "${PINK}"
printf '%s\n' \
    '███████╗ ██████╗██╗     ██╗██████╗ ███████╗███████╗' \
    '██╔════╝██╔════╝██║     ██║██╔══██╗██╔════╝██╔════╝' \
    '█████╗  ██║     ██║     ██║██████╔╝███████╗█████╗' \
    '██╔══╝  ██║     ██║     ██║██╔═══╝ ╚════██║██╔══╝' \
    '███████╗╚██████╗███████╗██║██║     ███████║███████╗' \
    '╚══════╝ ╚═════╝╚══════╝╚═╝╚═╝     ╚══════╝╚══════╝'

    printf "${PURPLE}    CACHYOS / HYPRLAND / NOCTALIA\n"
    printf "${GRAY}    INSTALLATION MANAGER — v1.0\n"
    printf "${PURPLE}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    printf "${RESET}\n"
}

pause() {
    printf "\n${GRAY}Press Enter to continue...${RESET}"
    read -r
}

while true; do
    header

    printf "${PINK}    [1] ${WHITE}Install ECLIPSE\n"
    printf "${PINK}    [2] ${WHITE}Install selected components\n"
    printf "${PINK}    [3] ${WHITE}Create backup\n"
    printf "${PINK}    [4] ${WHITE}Restore backup\n"
    printf "${PINK}    [5] ${WHITE}Compatibility check\n"
    printf "${PINK}    [6] ${WHITE}Install ECLIPSE Login\n"
    printf "${PINK}    [0] ${WHITE}Exit\n"

    printf "\n${PURPLE}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    printf "${PINK}    Select an option: ${RESET}"

    read -r choice || exit 0

    case "$choice" in
        3)
            bash "$ROOT/scripts/backup.sh"
            pause
            ;;
      4)
            bash "$ROOT/scripts/restore.sh"
            pause
            ;;
        5)
            bash "$ROOT/scripts/compatibility.sh"
            pause
            ;;
       2)
            bash "$ROOT/scripts/components.sh"
            pause
            ;;
        1)
            bash "$ROOT/scripts/install-all.sh"
            pause
            ;;
        6)
            bash "$ROOT/scripts/login.sh"
            pause
            ;;
            
        0)
            clear
            printf "${PINK}ECLIPSE // SESSION CLOSED${RESET}\n"
            exit 0
            ;;
        *)
            printf "\n${PINK}Invalid option.${RESET}\n"
            pause
            ;;
    esac
done
