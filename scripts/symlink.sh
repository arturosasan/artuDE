#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo " artuDE"
echo " Personal Hyprland dotfiles setup"
echo ""

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "  [!] Backing up $dest -> ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi

  if [[ -L "$dest" ]]; then
    rm "$dest"
  fi

  ln -s "$src" "$dest"
  echo "  -> $src -> $dest"
}

echo "[*] Creating symlinks..."

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
)

for dir in "${CONFIG_DIRS[@]}"; do
  src="$DOTFILES_DIR/$dir"
  if [[ -d "$src" ]]; then
    backup_and_link "$src" "$HOME/.config/$dir"
  fi
done

# Directories with renamed paths
backup_and_link "$DOTFILES_DIR/gtk/gtk-3.0" "$HOME/.config/gtk-3.0"
backup_and_link "$DOTFILES_DIR/gtk/gtk-4.0" "$HOME/.config/gtk-4.0"
backup_and_link "$DOTFILES_DIR/qt/qt6ct"   "$HOME/.config/qt6ct"
backup_and_link "$DOTFILES_DIR/fontconfig"  "$HOME/.config/fontconfig"
backup_and_link "$DOTFILES_DIR/systemd/user" "$HOME/.config/systemd/user"

# Files in ~/.config/
backup_and_link "$DOTFILES_DIR/mimeapps.list"  "$HOME/.config/mimeapps.list"
backup_and_link "$DOTFILES_DIR/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"

# Files in ~/
backup_and_link "$DOTFILES_DIR/gtk/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

echo ""
echo "[*] Symlinks created!"
echo ""
echo "Next steps:"
echo "  1. Log out and back in, or restart Hyprland"
echo "  2. Run 'hyprctl reload' to apply config changes"
