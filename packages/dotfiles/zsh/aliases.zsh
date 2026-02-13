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

# Obsidian
alias obs="cd \$MY_OBSIDIAN"
alias obse="cd \$MY_OBSIDIAN && nvim ."
alias obsvim="nvim \$MY_OBSIDIAN/.obsidian.vimrc"

# Project Paths
alias Code="cd $MY_CODE"
alias pr="Code && cd projects"
alias tuts="Code && cd tutorials"

# ----- Netflix Development -----
# Directory Navigation
alias Netflix="cd $MY_NETFLIX"
alias auiroot="Netflix && cd ai-animation-ui"

# Netflix CLI Tools
alias nnpm="newt exec npm"
alias nnpx="newt exec npx"
alias nnode="newt exec node"
alias nnpmr="newt exec npm run"
alias nyarn="newt exec yarn"
alias nyarnx="newt exec yarn dlx"
alias mtr="metatron enroll"
alias killuiport="killport 8180 && killport 8080 && killport 3000"

# Workstation UI
alias wsroot="cd $MY_WORKSTATION"
alias wui="cd $MY_WORKSTATION"
alias ws="killuiport && wsroot && newt exec npm install && newt develop-local --app manager"
alias wsp="killuiport && wsroot && newt exec npm install && newt develop-local --app manager --awsEnv prod"
alias wsschema="wsroot && npm run graphql:introspect -w manager"
alias wsgen="wsroot && npm run graphql:generate -w manager"
alias wscodegen="wsroot && npm run codegen -w manager"
alias wst="wsroot && npm test -w manager"
alias wstw="wsroot && npm run test:watch -w manager"
alias wsts="wsroot && npm run typecheck -w manager"
alias wslint="wsroot && npm run lint -w manager"
alias wse2e="wsroot && npm run test:e2e:local -w manager"
alias wsbuild="wsroot && npm run build -w manager"
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

alias sz="source ~/.zshrc"

# ----- Development Environment -----
alias de="cd $MY_DEV"
alias dee="cd $MY_DEV && nvim ."
alias des="cd $MY_DEV && bun run setup"

# ----- Nix -----
# Rebuild and switch system configuration (automatically cleans up old generations)
alias ns="sudo darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old"

# Update flake inputs and rebuild system
alias nu="cd $MY_NIX && nix flake update && ns"

# Open nix configuration in neovim
alias ne="cd $MY_NIX && nvim ."

# Kanata keyboard remapper
alias ks="sudo kanata -c ~/.config/kanata/kanata.kbd &>/dev/null & disown"
alias kk="sudo pkill -9 kanata"
alias kr="sudo launchctl kickstart -k system/com.github.jtroo.kanata"
# ----- Nix -----#

# AI
alias cc="claude --dangerously-skip-permissions"
alias oc="opencode"

# Dashlane
alias dash="dcli"

