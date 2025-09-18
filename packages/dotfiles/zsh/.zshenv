fpath=($fpath $HOME/.zsh/func)
typeset -U fpath

# ----- Environment Variables -----
# Custom paths
export MY_DEV="$HOME/dev-env" 
export MY_NIX="$MY_DEV/packages/nix" 
export MY_CODE="$HOME/Code"
export MY_NETFLIX="$MY_CODE/Netflix"
export MY_CAMPAIGN_SCRIPTS="$MY_NETFLIX/campaign-scripts"
export HAWKINS_COMPONENTS_PATH="$MY_NETFLIX/netflix-libs/node_modules/@hawkins/components"
export HAWKINS_TABLE_PATH="$MY_NETFLIX/netflix-libs/node_modules/@hawkins/table"
export HAWKINS_FORMS_PATH="$MY_NETFLIX/netflix-libs/node_modules/@hawkins/forms"


export CODEX_HOME="$HOME/.codex" # Codex configuration

# System and application settings
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export VISUAL="nvim"
export REACT_EDITOR="cursor"
export SDKMAN_DIR="$HOME/.sdkman"
export BUN_INSTALL="$HOME/.bun"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
export HOMEBREW_CASK_OPTS="--appdir=~/Applications --fontdir=~/Library/Fonts"

# API KEYS
export GEMINI_API_KEY=$(dcli read dl://30CE0913-42A6-4D70-8A97-AB13C6E72659/content)
export ANTHROPIC_API_KEY=$(dcli read dl://CAEE4745-21E1-4738-8400-D68A2A9C0DA4/content)
export ELEVENLABS_API_KEY=$(dcli read dl://39E8DADF-C93D-4070-97E6-8EB5AA942565/content)
export OPENAI_API_KEY="dummy"

# ni - Package manager selector configuration
export NI_CONFIG_FILE="$HOME/.config/ni/.nirc"

# ----- Path Configuration -----
# Base PATH
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$MY_CAMPAIGN_SCRIPTS/bin:$PATH"

# Tool-specific paths
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
