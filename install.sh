#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/dotfiles}"
BASH_SOURCE_FILE="$DOTFILES_DIR/bash/.bashrc"
BASH_TARGET="$HOME/.bashrc"
LOCAL_EXAMPLE="$DOTFILES_DIR/bash/.bashrc.local.example"
LOCAL_TARGET="$HOME/.bashrc.local"
GOOSE_CONFIG_SOURCE="$DOTFILES_DIR/config/goose/config.yaml"
GOOSE_CONFIG_TARGET="$HOME/.config/goose/config.yaml"
GOOSE_RECIPES_SOURCE="$DOTFILES_DIR/config/goose/recipes"
GOOSE_RECIPES_TARGET="$HOME/.config/goose/recipes"
FISH_CONFIG_SOURCE="$DOTFILES_DIR/config/fish/config.fish"
FISH_CONFIG_TARGET="$HOME/.config/fish/config.fish"
FISH_LOCAL_EXAMPLE="$DOTFILES_DIR/config/fish/config.local.example.fish"
FISH_LOCAL_TARGET="$HOME/.config/fish/config.local.fish"
KITTY_CONFIG_SOURCE="$DOTFILES_DIR/config/kitty/kitty.conf"
KITTY_CONFIG_TARGET="$HOME/.config/kitty/kitty.conf"
GHOSTTY_CONFIG_SOURCE="$DOTFILES_DIR/config/ghostty/config"
GHOSTTY_CONFIG_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_WRAPPER_SOURCE="$DOTFILES_DIR/bin/ghostty"
GHOSTTY_WRAPPER_TARGET="$HOME/.local/bin/ghostty"
GHOSTTY_DESKTOP_SOURCE="$DOTFILES_DIR/local/share/applications/com.mitchellh.ghostty.desktop"
GHOSTTY_DESKTOP_TARGET="$HOME/.local/share/applications/com.mitchellh.ghostty.desktop"
POLPO_SERVICE_SOURCE="$DOTFILES_DIR/config/systemd/user/polpo.service"
POLPO_SERVICE_TARGET="$HOME/.config/systemd/user/polpo.service"
HERMES_SERVICE_SOURCE="$DOTFILES_DIR/config/systemd/user/hermes-gateway.service"
HERMES_SERVICE_TARGET="$HOME/.config/systemd/user/hermes-gateway.service"
POLYMARKET_SERVICE_SOURCE="$DOTFILES_DIR/config/systemd/user/polymarket-insider-tracker.service"
POLYMARKET_SERVICE_TARGET="$HOME/.config/systemd/user/polymarket-insider-tracker.service"
PROXMOX_BUFFALO_SCRIPT_SOURCE="$DOTFILES_DIR/bin/proxmox-buffalo-backup"
PROXMOX_BUFFALO_SCRIPT_TARGET="$HOME/.local/bin/proxmox-buffalo-backup"
PROXMOX_BUFFALO_SERVICE_SOURCE="$DOTFILES_DIR/config/systemd/user/proxmox-buffalo-backup.service"
PROXMOX_BUFFALO_SERVICE_TARGET="$HOME/.config/systemd/user/proxmox-buffalo-backup.service"
PROXMOX_BUFFALO_TIMER_SOURCE="$DOTFILES_DIR/config/systemd/user/proxmox-buffalo-backup.timer"
PROXMOX_BUFFALO_TIMER_TARGET="$HOME/.config/systemd/user/proxmox-buffalo-backup.timer"
USER_SERVICES_AUTOSTART_SOURCE="$DOTFILES_DIR/config/autostart/hermes-user-services.desktop"
USER_SERVICES_AUTOSTART_TARGET="$HOME/.config/autostart/hermes-user-services.desktop"

backup_if_needed() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.pre-dotfiles.$(date +%Y%m%d-%H%M%S)"
        mv "$target" "$backup"
        echo "Backed up $target -> $backup"
    fi
}

if [ ! -f "$BASH_SOURCE_FILE" ]; then
    echo "Missing source file: $BASH_SOURCE_FILE" >&2
    exit 1
fi

backup_if_needed "$BASH_TARGET"
ln -sfn "$BASH_SOURCE_FILE" "$BASH_TARGET"
echo "Linked $BASH_TARGET -> $BASH_SOURCE_FILE"

if [ ! -e "$LOCAL_TARGET" ] && [ -f "$LOCAL_EXAMPLE" ]; then
    cp "$LOCAL_EXAMPLE" "$LOCAL_TARGET"
    echo "Created $LOCAL_TARGET from example"
fi

if [ -f "$GOOSE_CONFIG_SOURCE" ]; then
    mkdir -p "$(dirname "$GOOSE_CONFIG_TARGET")"
    backup_if_needed "$GOOSE_CONFIG_TARGET"
    ln -sfn "$GOOSE_CONFIG_SOURCE" "$GOOSE_CONFIG_TARGET"
    echo "Linked $GOOSE_CONFIG_TARGET -> $GOOSE_CONFIG_SOURCE"
fi

if [ -d "$GOOSE_RECIPES_SOURCE" ]; then
    mkdir -p "$(dirname "$GOOSE_RECIPES_TARGET")"
    backup_if_needed "$GOOSE_RECIPES_TARGET"
    ln -sfn "$GOOSE_RECIPES_SOURCE" "$GOOSE_RECIPES_TARGET"
    echo "Linked $GOOSE_RECIPES_TARGET -> $GOOSE_RECIPES_SOURCE"
fi

if [ -f "$FISH_CONFIG_SOURCE" ]; then
    mkdir -p "$(dirname "$FISH_CONFIG_TARGET")"
    backup_if_needed "$FISH_CONFIG_TARGET"
    ln -sfn "$FISH_CONFIG_SOURCE" "$FISH_CONFIG_TARGET"
    echo "Linked $FISH_CONFIG_TARGET -> $FISH_CONFIG_SOURCE"
fi

if [ ! -e "$FISH_LOCAL_TARGET" ] && [ -f "$FISH_LOCAL_EXAMPLE" ]; then
    mkdir -p "$(dirname "$FISH_LOCAL_TARGET")"
    cp "$FISH_LOCAL_EXAMPLE" "$FISH_LOCAL_TARGET"
    echo "Created $FISH_LOCAL_TARGET from example"
fi

if [ -f "$KITTY_CONFIG_SOURCE" ]; then
    mkdir -p "$(dirname "$KITTY_CONFIG_TARGET")"
    backup_if_needed "$KITTY_CONFIG_TARGET"
    ln -sfn "$KITTY_CONFIG_SOURCE" "$KITTY_CONFIG_TARGET"
    echo "Linked $KITTY_CONFIG_TARGET -> $KITTY_CONFIG_SOURCE"
fi

if [ -f "$GHOSTTY_CONFIG_SOURCE" ]; then
    mkdir -p "$(dirname "$GHOSTTY_CONFIG_TARGET")"
    backup_if_needed "$GHOSTTY_CONFIG_TARGET"
    ln -sfn "$GHOSTTY_CONFIG_SOURCE" "$GHOSTTY_CONFIG_TARGET"
    echo "Linked $GHOSTTY_CONFIG_TARGET -> $GHOSTTY_CONFIG_SOURCE"
fi

if [ -f "$GHOSTTY_WRAPPER_SOURCE" ]; then
    mkdir -p "$(dirname "$GHOSTTY_WRAPPER_TARGET")"
    backup_if_needed "$GHOSTTY_WRAPPER_TARGET"
    ln -sfn "$GHOSTTY_WRAPPER_SOURCE" "$GHOSTTY_WRAPPER_TARGET"
    chmod +x "$GHOSTTY_WRAPPER_SOURCE"
    echo "Linked $GHOSTTY_WRAPPER_TARGET -> $GHOSTTY_WRAPPER_SOURCE"
fi

if [ -f "$GHOSTTY_DESKTOP_SOURCE" ]; then
    mkdir -p "$(dirname "$GHOSTTY_DESKTOP_TARGET")"
    backup_if_needed "$GHOSTTY_DESKTOP_TARGET"
    ln -sfn "$GHOSTTY_DESKTOP_SOURCE" "$GHOSTTY_DESKTOP_TARGET"
    echo "Linked $GHOSTTY_DESKTOP_TARGET -> $GHOSTTY_DESKTOP_SOURCE"
fi

if [ -f "$POLPO_SERVICE_SOURCE" ]; then
    mkdir -p "$(dirname "$POLPO_SERVICE_TARGET")"
    backup_if_needed "$POLPO_SERVICE_TARGET"
    ln -sfn "$POLPO_SERVICE_SOURCE" "$POLPO_SERVICE_TARGET"
    echo "Linked $POLPO_SERVICE_TARGET -> $POLPO_SERVICE_SOURCE"
    systemctl --user daemon-reload
    systemctl --user enable --now polpo.service
    echo "Enabled and started polpo.service"
fi

if [ -f "$HERMES_SERVICE_SOURCE" ]; then
    mkdir -p "$(dirname "$HERMES_SERVICE_TARGET")"
    backup_if_needed "$HERMES_SERVICE_TARGET"
    ln -sfn "$HERMES_SERVICE_SOURCE" "$HERMES_SERVICE_TARGET"
    echo "Linked $HERMES_SERVICE_TARGET -> $HERMES_SERVICE_SOURCE"
    systemctl --user daemon-reload
    systemctl --user enable --now hermes-gateway.service
    echo "Enabled and started hermes-gateway.service"
fi

if [ -f "$POLYMARKET_SERVICE_SOURCE" ]; then
    mkdir -p "$(dirname "$POLYMARKET_SERVICE_TARGET")"
    backup_if_needed "$POLYMARKET_SERVICE_TARGET"
    ln -sfn "$POLYMARKET_SERVICE_SOURCE" "$POLYMARKET_SERVICE_TARGET"
    echo "Linked $POLYMARKET_SERVICE_TARGET -> $POLYMARKET_SERVICE_SOURCE"
    systemctl --user daemon-reload
    systemctl --user enable --now polymarket-insider-tracker.service
    echo "Enabled and started polymarket-insider-tracker.service"
fi

if [ -f "$PROXMOX_BUFFALO_SCRIPT_SOURCE" ]; then
    mkdir -p "$(dirname "$PROXMOX_BUFFALO_SCRIPT_TARGET")"
    backup_if_needed "$PROXMOX_BUFFALO_SCRIPT_TARGET"
    ln -sfn "$PROXMOX_BUFFALO_SCRIPT_SOURCE" "$PROXMOX_BUFFALO_SCRIPT_TARGET"
    chmod +x "$PROXMOX_BUFFALO_SCRIPT_SOURCE"
    echo "Linked $PROXMOX_BUFFALO_SCRIPT_TARGET -> $PROXMOX_BUFFALO_SCRIPT_SOURCE"
fi

if [ -f "$PROXMOX_BUFFALO_SERVICE_SOURCE" ] && [ -f "$PROXMOX_BUFFALO_TIMER_SOURCE" ]; then
    mkdir -p "$(dirname "$PROXMOX_BUFFALO_SERVICE_TARGET")"
    backup_if_needed "$PROXMOX_BUFFALO_SERVICE_TARGET"
    backup_if_needed "$PROXMOX_BUFFALO_TIMER_TARGET"
    ln -sfn "$PROXMOX_BUFFALO_SERVICE_SOURCE" "$PROXMOX_BUFFALO_SERVICE_TARGET"
    ln -sfn "$PROXMOX_BUFFALO_TIMER_SOURCE" "$PROXMOX_BUFFALO_TIMER_TARGET"
    systemctl --user daemon-reload
    systemctl --user enable --now proxmox-buffalo-backup.timer
    echo "Enabled proxmox-buffalo-backup.timer"
fi

if [ -f "$USER_SERVICES_AUTOSTART_SOURCE" ]; then
    mkdir -p "$(dirname "$USER_SERVICES_AUTOSTART_TARGET")"
    backup_if_needed "$USER_SERVICES_AUTOSTART_TARGET"
    ln -sfn "$USER_SERVICES_AUTOSTART_SOURCE" "$USER_SERVICES_AUTOSTART_TARGET"
    echo "Linked $USER_SERVICES_AUTOSTART_TARGET -> $USER_SERVICES_AUTOSTART_SOURCE"
fi

echo "Done. Start a new shell or run: source ~/.bashrc"
