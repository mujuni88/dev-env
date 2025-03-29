# Initialize Starship prompt
eval "$(starship init zsh)"

# ----- Environment Variables -----
# Custom paths
export MY_DEV="$HOME/dev-env"                # Development environment root
export MY_NIX="$MY_DEV/nix"                  # Nix configuration
export MY_CODE="$HOME/Code"
export MY_NETFLIX="$MY_CODE/Netflix"
export MY_CAMPAIGN_SCRIPTS="$MY_NETFLIX/campaign-scripts"

# System and application settings
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export VISUAL="nvim"
export REACT_EDITOR="cursor"
export SDKMAN_DIR="$HOME/.sdkman"
export BUN_INSTALL="$HOME/.bun"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
export HOMEBREW_CASK_OPTS="--appdir=~/Applications --fontdir=~/Library/Fonts"

# ----- Path Configuration -----
# Base PATH
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:$MY_CAMPAIGN_SCRIPTS/bin:$PATH"

# Tool-specific paths
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.console-ninja/.bin:$PATH"
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# ----- History Configuration -----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST

# ----- Version Control Info -----
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'

# ----- Tool Configurations -----
# Jabba (Java Version Manager)
[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Fnm
FNM_PATH="$HOME/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# Zoxide
eval "$(zoxide init zsh)"

# ----- Load Additional Configs -----
# Load all zsh config files eg. aliases.zsh
for config_file (~/.config/zsh/*.zsh(N)); do
  source $config_file
done
