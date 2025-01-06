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
alias valias="vim $ZSH/custom/plugins/alias/alias.plugin.zsh"
alias vsh="vim ~/.zshrc"
alias vwez="vim $MYWEZ_CONFIG/config.lua"

# NVIM config
alias vplug="vim $MYVIM_CONFIG/plugins.vim"
alias vnerd="vim $MYVIM_CONFIG/settings/nerdtree.vim"
alias vmap="vim $MYVIM_CONFIG/settings/mappings.vim"
alias vjs="vim $MYVIM_CONFIG/settings/javascript.vim"
alias vconf="vim $MYVIM_CONFIG/settings/config.vim"

# Project Paths
alias Code="cd ~/Code/"
alias pr="Code && cd projects"
alias tuts="Code && cd tutorials"
alias aliases="$ZSH/custom/plugins/alias/"
alias dtf="$HOME/.dotfiles/"
alias Netflix="Code && cd Netflix"
alias auiroot="Netflix && cd ai-animation-ui"

# Tmux
alias tmn="tmux new-session -s"
alias tma="tmux attach -t"
alias tml="tmux ls"
alias tmk="tmux kill-session -t"
alias tmd="tmux detach -a"
alias tmka="killall tmux"

# ZSH Aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim $ZSH"

# Updated npm aliases
alias nnpm="newt exec npm"
alias nnpx="newt exec npx"
alias nnode="newt exec node"
alias nnpmr="newt exec npm run"
alias npmr="npm run"

# Apps
alias killuiport="killport 8180 && killport 8080 && killport 3000"

# Workspace aliases
alias sharedw="nnpm --workspace=@animation-ui/shared-components"

alias aconw="nnpm --workspace=@animation-ui/animation-connect"
alias acons="killuiport && auiroot && nnpm install && newt develop --app animation-connect"
alias acont="aconw run get-types:watch"

alias ebayw="nnpm --workspace=@animation-ui/editbay"
alias ebays="killuiport && auiroot && nnpm install && newt develop --app editbay"
alias ebayslocal="killuiport && auiroot && nnpm install && newt develop --app editbay"
alias ebayt="ebayw run generate-types"
alias ebaytw="ebayw run generate-types:watch"
alias ebaytwi="ebayw run generate-types:integration"
alias ebaytest="ebayw run test"
alias ebaytestonce="ebayw run test:once"

alias speakw="nnpm --workspace=@animation-ui/speakeasy"
alias speaks="killuiport && auiroot && nnpm install && newt develop --app speakeasy"
alias speaklocal="killuiport && auiroot && nnpm install && newt develop --app speakeasy"
alias speakt="speakw run generate-types"
alias speaktw="speakw run generate-types:watch"

alias assetw="nnpm --workspace=@animation-ui/asset-spotting"
alias assets="killuiport && auiroot && nnpm install && newt develop --app asset-spotting"

alias pashw="nnpm --workspace=@animation-ui/pashboard-v2"
alias pasht="pashw run generate-types"
alias pashs="killuiport && auiroot && nnpm install && newt develop --app pashboard-v2"

alias sbookw="nnpm --workspace=@animation-ui/storybook"
alias sbooks="killport 6006 && auiroot && nnpm install && newt develop --app storybook"

# Open repository
alias sdm="open https://stash.corp.netflix.com/projects/SUIM/repos/studio-ui-media/pull-requests"
alias npca="open https://stash.corp.netflix.com/projects/CCEUI/repos/npca-ui/pull-requests"
alias openacui="open https://stash.corp.netflix.com/projects/AI/repos/animation-ui/pull-requests"
alias sdc="open https://stash.corp.netflix.com/projects/HAWK/repos/studio-ui-common/pull-requests"
alias mtr="metatron refresh"
alias botserver="Code && ssh -i "gdaxKey.pem" ec2-user@ec2-100-26-46-177.compute-1.amazonaws.com"

alias killvpn="sudo kill -SEGV $(ps auwx | grep dsAccessService | grep Ss | awk '{print $2}')"

alias pgstart="brew services start postgresql@16"
alias pgstop="brew services stop postgresql@16"
alias pg='psql postgres'

alias szsh="source /Users/jbuza/.dotfiles/homedir/.zshrc"

# ----- Development Environment -----
alias devenv="cd $MY_DEV"
alias devedit="cd $MY_DEV && nvim ."

# ----- Dotfiles -----
alias dots="cd $MY_DEV/dotfiles && stow -R ."
alias dotsedit="cd $MY_DEV/dotfiles && nvim ."

# ----- Nix -----
alias nixswitch="darwin-rebuild switch --flake $MY_NIX#macos && nix-collect-garbage --delete-old"  # switch and clean
alias nixup="cd $MY_NIX && nix flake update && nixswitch"                                         # update and switch
alias nixedit="cd $MY_NIX && nvim ."                                                              # edit nix config
