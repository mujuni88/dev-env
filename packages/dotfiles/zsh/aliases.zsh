# File management
alias ll="eza --color=always --long --git --icons=always --no-time --no-user --all --tree --level=1 --git-ignore"
alias df="df -h"
alias rm="rm -i"
alias cp="cp -i"
alias j="z"
alias lg="lazygit"
alias lzd="lazydocker"
alias cat="bat"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Vim
alias vi="nvim"
alias vim="nvim"
alias zshedit="vim ~/.zshrc"
alias vimedit="cd ~/.config/nvim && nvim ."
alias claudemcp="nvim ~/Library/Application\ Support/Claude/claude_desktop_config.json"
alias claudeconfig="nvim /Users/jbuza/.claude.json"

# Project Paths
alias Code="cd $MY_CODE"
alias pr="Code && cd projects"
alias tuts="Code && cd tutorials"

# ----- Netflix Development -----
# Directory Navigation
alias Netflix="cd $MY_NETFLIX"
alias auiroot="Netflix && cd ai-animation-ui"
alias caroot="Netflix && cd pxd-spotlight-ui"

# Netflix CLI Tools
alias nnpm="newt exec npm"
alias nnpx="newt exec npx"
alias nnode="newt exec node"
alias nnpmr="newt exec npm run"
alias nyarn="newt exec yarn"
alias nyarnx="newt exec yarn dlx"
alias mtr="metatron enroll"
alias killuiport="killport 8180 && killport 8080 && killport 3000"

# Campaign UI
alias camp="killuiport && caroot && nyarn install && newt develop"
alias camplocal="killuiport && caroot && nyarn install && newt develop-local"
alias campschema="caroot && nyarn fetch-schema"
alias campgen="caroot && nyarn graphql:generate" 
alias campstory="killport 6006 && caroot && nyarn storybook" 
alias campt="caroot && nyarn test:plugin campaigns"
alias campts="caroot && nyarn workspace @netflix-console/plugin-campaigns typecheck"
alias casts="caroot && nyarn workspace @netflix-console/plugin-common-campaigns typecheck"
alias cast="caroot && nyarn workspace @netflix-console/plugin-common-campaigns test"

alias campnew='create_full_campaign "Joe Test Campaign" "Test campaign for Joe" jbuza SERVICE test'
alias campnewprod='create_full_campaign "Joe Test Campaign" "Test campaign for Joe" jbuza SERVICE prod'
# ----- End Netflix Development -----

# Tmux
alias tmn="tmux new-session -s"
alias tma="tmux attach -t"
alias tml="tmux ls"
alias tmk="tmux kill-session -t"
alias tmd="tmux detach"
alias tmka="killall tmux"
alias tmuxedit="nvim ~/tmux/.config/tmux/.tmux.conf"

# Zellij
alias zj="zellij"
alias zja="zellij attach -c"
alias zjd="zellij detach"
alias zjl="zellij list-sessions"
alias zjk="zellij kill-session"
alias zjka="zellij kill-all-sessions"
alias zjd="zellij delete-session"
alias zjda="zellij delete-all-sessions"
alias zjedit="nvim ~/.config/zellij/config.kdl"

alias killvpn="sudo kill -SEGV $(ps auwx | grep dsAccessService | grep Ss | awk '{print $2}')"

alias pgstart="brew services start postgresql@16"
alias pgstop="brew services stop postgresql@16"
alias pg='psql postgres'

alias szsh="source ~/.zshrc"

# ----- Development Environment -----
alias devenv="cd $MY_DEV"
alias devedit="cd $MY_DEV && nvim ."
# One command to update and set up the entire development environment
alias devsetup="cd $MY_DEV && bun run setup"

# ----- Dotfiles -----
alias dotsedit="cd $MY_DEV/packages/dotfiles && nvim ."

# ----- Nix -----
# Rebuild and switch system configuration (automatically cleans up old generations)
alias nixswitch="sudo darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old"

# Update flake inputs and rebuild system
alias nixup="cd $MY_NIX && nix flake update && nixswitch"

# Open nix configuration in neovim
alias nixedit="cd $MY_NIX && nvim ."
# ----- Nix -----#

# AI
alias claude="claude --dangerously-skip-permissions"

# Dashlane
alias dash="dcli"

# Claude
alias claude-mem='bun "/Users/jbuza/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
