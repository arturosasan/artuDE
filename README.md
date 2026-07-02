# artuDE

**artuDE**  is a collection of personal dotfiles for [Hyprland](https://hyprland.org/), a dynamic tiling Wayland compositor. It provides a cohesive, visually consistent setup spanning the window manager, status bar, notification daemon, application launcher, GTK/Qt theming, and a curated set of terminal (TUI) tools.

The repository is designed to be instantly deployable on a fresh Arch Linux installation — the installer script handles both package installation and symlink creation.

---

## Features

- **Dynamic tiling WM** — Hyprland with custom keybinds, window rules, and animations
- **Modern status bar** — Waybar with custom modules (audio, network, system stats, Hyprland workspaces)
- **Notification center** — SwayNC with a clean, minimal look
- **App launcher** — Rofi with a custom theme
- **Consistent theming** — GTK3/4, Qt6 (via qt6ct), and nwg-look integration for a unified look across native and Electron apps
- **Terminal ecosystem** — Preconfigured Neovim, Yazi (file manager), Btop (system monitor), Cava (audio visualizer), Fastfetch (system info), Broot (directory tree), and Lazygit (Git UI)
- **Audio** — PipeWire/WirePlumber controls bound to media keys
- **System services** — Systemd user units, custom MIME associations, and XDG user directories
- **Fonts** — Fontconfig preferences included

---

## What's included

| Category | Tools |
|---|---|
| **Window Manager** | Hyprland, Hyprlock, Hyprpaper |
| **Logout** | Wlogout |
| **Bar** | Waybar + custom scripts |
| **Notifications** | SwayNC |
| **Launcher** | Rofi |
| **Theming** | GTK3/4, Qt6ct, nwg-look, xsettingsd, fontconfig |
| **TUI tools** | Neovim, Yazi, Btop, Cava, Fastfetch, Broot, Lazygit |
| **Audio** | PipeWire/WirePlumber launcher bindings |
| **System** | Systemd user services, MIME types, user dirs |

---

## Requirements

- **OS:** Arch Linux (the installer uses `pacman`)
- **Display server:** Wayland (Hyprland)
- **GPU:** Modern GPU with DRM support (Intel, AMD, or NVIDIA with open-source drivers)

---

## Quick start

```bash
git clone https://github.com/arturosasan/artuDE.git ~/artuDE
cd ~/artuDE
./install.sh
```

The installer will:
1. Install all required packages via `pacman`
2. Symlink every configuration directory to `~/.config/`

After completion, log out, select **Hyprland** from your display manager, or launch it from a TTY with `Hyprland`.

---

## Manual steps (post-install)

- **Fastfetch logo:** Create `~/.config/images/arch.txt` with an ASCII logo, or remove the `logo` section from `fastfetch/config.jsonc`
- **GTK bookmarks:** Edit `gtk/gtk-3.0/bookmarks` and replace paths with your actual home directories

---

## Structure

```
artuDE/
├── hypr/         → ~/.config/hypr/          # Hyprland config, keybinds, window rules
├── waybar/       → ~/.config/waybar/        # Status bar configuration and styles
├── swaync/       → ~/.config/swaync/        # Notification daemon
├── rofi/         → ~/.config/rofi/          # Application launcher
├── gtk/
│   ├── gtk-3.0/  → ~/.config/gtk-3.0/      # GTK3 settings
│   └── gtk-4.0/  → ~/.config/gtk-4.0/      # GTK4 settings
├── qt/qt6ct/     → ~/.config/qt6ct/        # Qt6 appearance
├── nvim/         → ~/.config/nvim/          # Neovim configuration
├── yazi/         → ~/.config/yazi/          # Terminal file manager
├── btop/         → ~/.config/btop/          # System monitor
├── cava/         → ~/.config/cava/          # Audio visualizer
├── fastfetch/    → ~/.config/fastfetch/     # System info display
├── broot/        → ~/.config/broot/         # Directory tree explorer
├── lazygit/      → ~/.config/lazygit/       # Git TUI
├── rofi/         → ~/.config/rofi/          # App launcher
├── fontconfig/   → ~/.config/fontconfig/    # Font rendering preferences
├── wlogout/      → ~/.config/wlogout/       # Logout menu
├── scripts/      → installer and helper scripts
└── install.sh    → entry point (detects OS and runs install-arch.sh + symlink.sh)
```

---

## Related projects

- [artuKitty](https://github.com/arturosasan/artuKitty) — Terminal config (Kitty, Zsh, Git, etc.), designed to pair with artuDE

---

## License

GPL-3.0