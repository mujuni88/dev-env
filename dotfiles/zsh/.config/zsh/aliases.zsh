# File management
alias ls="eza --color=always --long --git --icons=always --no-time --no-user --all --tree --level=1 --git-ignore"
alias cat="bat"
alias df="df -h"
alias rm="rm -i"
alias cp="cp -i"
alias cd="z"
alias j="z"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Vim
alias vi="nvim"
alias vim="nvim"
alias vsh="vim ~/.zshrc"


# Project Paths
alias Code="cd ~/Code/"
alias pr="Code && cd projects"
alias tuts="Code && cd tutorials"

# ----- Netflix Development -----
# Directory Navigation
alias Netflix="Code && cd Netflix"
alias auiroot="Netflix && cd ai-animation-ui"
alias caroot="Netflix && cd pxd-spotlight-ui"

# Netflix CLI Tools
alias nnpm="newt exec npm"
alias nnpx="newt exec npx"
alias nnode="newt exec node"
alias nnpmr="newt exec npm run"
alias nyarn="newt exec yarn"
alias nyarnx="newt exec yarn dlx"
alias mtr="metatron refresh"
alias killuiport="killport 8180 && killport 8080 && killport 3000"

# Speakeasy (AI Animation UI)
alias speakw="nnpm --workspace=@animation-ui/speakeasy"
alias speaks="killuiport && auiroot && nnpm install && newt develop --app speakeasy"
alias speakt="speakw run generate-types"
alias speaktw="speakw run generate-types:watch"

# Campaign Assistant UI
alias camp="killuiport && caroot && nyarn install && newt develop"
alias campgen="caroot && nyarn graphql:generate" 
alias campstory="caroot && nyarn storybook" 
alias campt="caroot && nyarn test:plugin campaigns"
alias campts="caroot && nyarn workspace @netflix-console/campaign-assistant-components typecheck"
alias camppts="caroot && nyarn workspace @netflix-console/plugin-campaigns typecheck"

# ----- End Netflix Development -----

# Tmux
alias tmn="tmux new-session -s"
alias tma="tmux attach -t"
alias tml="tmux ls"
alias tmk="tmux kill-session -t"
alias tmd="tmux detach -a"
alias tmka="killall tmux"

alias killvpn="sudo kill -SEGV $(ps auwx | grep dsAccessService | grep Ss | awk '{print $2}')"

alias pgstart="brew services start postgresql@16"
alias pgstop="brew services stop postgresql@16"
alias pg='psql postgres'

alias szsh="source ~/.zshrc"

# ----- Development Environment -----
alias devenv="cd $MY_DEV"
alias devedit="cd $MY_DEV && nvim ."
alias aeroedit="cd $MY_DEV/dotfiles/aerospace/.config/aerospace/ && nvim aerospace.toml"

# ----- Dotfiles -----
alias dots="cd $MY_DEV/dotfiles && stow -v -R */"
alias dotsedit="cd $MY_DEV/dotfiles && nvim ."

# ----- Nix -----
# Rebuild and switch system configuration (automatically cleans up old generations)
alias nixswitch="darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old"

# Update flake inputs and rebuild system
alias nixup="cd $MY_NIX && nix flake update && nixswitch"

# Open nix configuration in neovim
alias nixedit="cd $MY_NIX && nvim ."
