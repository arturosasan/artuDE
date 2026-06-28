#!/usr/bin/env bash
set -uo pipefail

if ! command -v pacman &>/dev/null; then
  echo "[!] This script requires pacman (Arch Linux)"
  exit 1
fi

install_pkg() {
  sudo pacman -S --noconfirm "$@"
}

try_install() {
  local name="$1"
  shift
  echo "  -> $name"
  if ! "$@"; then
    echo "  [!] $name install failed (non-fatal, continuing)"
  fi
}

echo "[*] Updating package lists..."
sudo pacman -Sy || true

echo ""
echo "[*] Installing Hyprland & core DE..."
install_pkg hyprland hyprlock hyprpaper waybar swaync rofi wayland-utils || true
try_install "xdg-desktop-portal-hyprland" sudo pacman -S --noconfirm xdg-desktop-portal-hyprland || true
try_install "screenshot (hyprshot)" sudo pacman -S --noconfirm hyprshot grim slurp || true

echo ""
echo "[*] Installing GTK/Qt theming..."
install_pkg gtk3 gtk4 qt6ct nwg-look xsettingsd || true

echo ""
echo "[*] Installing audio..."
install_pkg pipewire wireplumber pipewire-pulse pamixer pavucontrol || true

echo ""
echo "[*] Installing network & Bluetooth..."
install_pkg networkmanager iwd bluez bluez-utils blueman || true

echo ""
echo "[*] Installing TUI tools (lanzables desde Waybar)..."
install_pkg neovim yazi btop cava fastfetch broot lazygit || true

echo ""
echo "[*] Installing utilities..."
install_pkg brightnessctl playerctl polkit-kde-agent || true

echo ""
echo "[*] Installing JetBrainsMono Nerd Font..."
if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
  echo "  -> Downloading JetBrainsMono Nerd Font..."
  mkdir -p "$HOME/.local/share/fonts"
  if curl -Lo /tmp/JetBrainsMono.zip \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"; then
    unzip -o /tmp/JetBrainsMono.zip -d "$HOME/.local/share/fonts/JetBrainsMono" >/dev/null 2>&1
    fc-cache -f >/dev/null 2>&1
    rm -f /tmp/JetBrainsMono.zip
    echo "  -> Font installed"
  else
    echo "  [!] Font download failed (non-fatal, install manually)"
  fi
else
  echo "  -> Already installed"
fi

echo ""
echo "[*] Enabling services..."
try_install "pipewire" systemctl --user enable pipewire pipewire-pulse wireplumber 2>/dev/null || true
try_install "NetworkManager" sudo systemctl enable NetworkManager 2>/dev/null || true
try_install "bluetooth" sudo systemctl enable bluetooth 2>/dev/null || true

echo ""
echo "[*] Package installation complete!"
echo ""
echo "Next: run 'bash scripts/symlink.sh' to link configs"
