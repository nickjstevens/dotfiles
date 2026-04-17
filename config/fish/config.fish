# Fish shell configuration tracked in ~/Documents/dotfiles/config/fish/config.fish

if status is-interactive
    if command -sq starship
        starship init fish | source
    end
end

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
