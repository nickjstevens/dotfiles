#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Documents/dotfiles}"
BASH_SOURCE_FILE="$DOTFILES_DIR/bash/.bashrc"
BASH_TARGET="$HOME/.bashrc"
LOCAL_EXAMPLE="$DOTFILES_DIR/bash/.bashrc.local.example"
LOCAL_TARGET="$HOME/.bashrc.local"

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

echo "Done. Start a new shell or run: source ~/.bashrc"
