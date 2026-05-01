# Fish shell configuration tracked in ~/Documents/dotfiles/config/fish/config.fish

# fish_add_path prepends by default, so add broader paths before ~/.local/bin
# to keep user-local wrappers highest priority. -m also fixes older saved order.
fish_add_path -m ~/.npm-global/bin
fish_add_path -m ~/.opencode/bin
fish_add_path -m ~/.local/bin

if status is-interactive
    if command -sq starship
        starship init fish | source
    end
end

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

# Added by OpenAgents installer
fish_add_path /home/nick/.openagents/nodejs/bin
fish_add_path /home/nick/.openagents/nodejs/node_modules/.bin
