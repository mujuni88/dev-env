# ----- Completion Configuration -----
autoload -U compinit
compinit
unsetopt correct

# Load Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
    
    # Initialize zsh-autosuggestions
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    
    # Initialize zsh-syntax-highlighting (must be after other plugins)
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    # Initialize zsh-autocomplete (must be last)
    source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
bindkey '^[[Z' autosuggest-accept  # Shift + Tab to accept suggestion

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