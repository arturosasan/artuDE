#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo " artuDE"
echo " Personal Hyprland dotfiles setup"
echo ""

OS="$(uname -s)"
case "$OS" in
  Linux)
    echo "[*] Detected Linux"
    bash "$DOTFILES_DIR/scripts/install-arch.sh"
    ;;
  Darwin)
    echo "[!] macOS not supported (Hyprland requires Linux)"
    exit 1
    ;;
  *)
    echo "[!] Unsupported OS: $OS"
    exit 1
    ;;
esac

echo ""
echo "[*] Running symlink setup..."
bash "$DOTFILES_DIR/scripts/symlink.sh"

echo ""
echo "=================================="
echo "  Setup complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "  1. Log out and select Hyprland from your display manager"
echo "  2. Or run 'Hyprland' from a TTY"
