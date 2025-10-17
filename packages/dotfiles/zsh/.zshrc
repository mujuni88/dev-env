# Initialize Starship prompt
eval "$(starship init zsh)"

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
# SDKMAN (Homebrew installation)
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# ----- Load Additional Configs -----
# Load all zsh config files eg. aliases.zsh
for config_file (~/.config/zsh/*.zsh(N)); do
  source $config_file
done
