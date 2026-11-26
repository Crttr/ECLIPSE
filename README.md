# ECLIPSE v1.0

> SYSTEM ONLINE // WELCOME TO ECLIPSE

Custom desktop environment configuration for CachyOS.

## Design

- Dark pink and purple aesthetic
- Hyprland Lua configuration
- Noctalia Shell
- Custom terminal appearance
- Kvantum and Qt themes
- GTK and Dolphin customization
- Custom cursors and wallpapers
- Animated Tuigreet login screen

## Requirements

- CachyOS
- Hyprland with Lua configuration support
- Noctalia 5.6 or compatible version
- Bash
- UWSM
- Required applications and themes

## Installation

Extract the archive and open its directory.

Run:

    bash install.sh

## Installer modules

1. Install ECLIPSE
2. Install selected components
3. Create backup
4. Restore backup
5. Compatibility check
6. Install ECLIPSE Login
0. Exit

Run the compatibility check before installation.

## Safety

The installer creates user configuration backups before installation.

Restore merges saved configuration files and does not remove newly created files.

The login module modifies /etc/greetd and creates a separate system backup.

No automatic reboot or service restart is performed.

Review monitor settings, wallpaper paths and application dependencies before logging out.

Do not run the main installer as root.

## Compatibility

Reference system:
- CachyOS
- x86_64
- Wayland
- Hyprland
- Noctalia 5.6.0
- NVIDIA GTX 1660 Ti

## Release status

Version: 1.0
Status: Preview

Installer syntax and menu navigation tested.
Clean-system installation and complete rollback not yet validated.

Package installation is not automated.
Hardware-specific settings may require manual adjustment.

## Credits

ECLIPSE configuration project by Crttr.

Third-party software, icons, cursors and artwork belong to their respective authors. Redistribution rights must be verified before public distribution.

---

ECLIPSE // SYSTEM ONLINE
