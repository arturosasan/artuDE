#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo " artuDE"
echo " Uninstalling symlinks"
echo ""

restore_backup() {
  local dest="$1"
  if [[ -L "$dest" ]]; then
    rm "$dest"
    echo "  -> Removed symlink: $dest"
    if [[ -e "${dest}.backup" ]]; then
      mv "${dest}.backup" "$dest"
      echo "  -> Restored backup: ${dest}.backup -> $dest"
    fi
  fi
}

echo "[*] Removing symlinks..."

# Directories in ~/.config/ that map 1:1
CONFIG_DIRS=(
  "hypr"
  "waybar"
  "swaync"
  "rofi"
  "nvim"
  "yazi"
  "btop"
  "cava"
  "fastfetch"
  "broot"
  "htop"
  "lazygit"
  "xsettingsd"
  "nwg-look"
  "wlogout"
  "swaync"
)

for dir in "${CONFIG_DIRS[@]}"; do
  restore_backup "$HOME/.config/$dir"
done

# Directories with renamed paths
restore_backup "$HOME/.config/gtk-3.0"
restore_backup "$HOME/.config/gtk-4.0"
restore_backup "$HOME/.config/qt6ct"
restore_backup "$HOME/.config/fontconfig"
restore_backup "$HOME/.config/systemd/user"

# Files in ~/.config/
restore_backup "$HOME/.config/mimeapps.list"
restore_backup "$HOME/.config/user-dirs.dirs"

# Files in ~/
restore_backup "$HOME/.gtkrc-2.0"

echo ""
echo "[*] Done! Configs restored from backups (if available)."
