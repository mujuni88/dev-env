# ----- Completion Configuration -----
autoload -U compinit
compinit
unsetopt correct

# Load Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
    
    # Initialize zsh-syntax-highlighting
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    # Initialize zsh-autocomplete
    source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Docker completions
fpath=(/Users/jbuza/.docker/completions $fpath)

# Completion settings
zstyle ':completion:*' menu select  # Enable menu-style completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''  # Group completion by category
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format '%F{yellow}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches found%f' 