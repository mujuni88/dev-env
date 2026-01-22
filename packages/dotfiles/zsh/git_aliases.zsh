# Git Shell Aliases
# These are short shell shortcuts. Full git aliases are in ~/.gitconfig
# Use `git <alias>` for tab completion, or these shortcuts for speed.

# Core commands
alias gs='git status'
alias gst='git st'           # uses gitconfig alias
alias gsts='git st -s'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gcam='git cam'         # uses gitconfig alias (commit -am)
alias gca='git commit --amend'
alias gcmd='git commadd'     # uses gitconfig alias (add -A && amend)

# Branches & Checkout
alias gco='git co'           # uses gitconfig alias
alias gcb='git checkout -b'
alias gb='git branch'
alias gbm='git br -m'
alias gbnew='git br-new'     # uses gitconfig alias (branch sorted newest)
alias gbold='git br-old'     # uses gitconfig alias (branch sorted oldest)
alias gm='git co main'

# Pull, Push, Fetch
alias gp='git push'
alias gpf='git please'       # uses gitconfig alias (push --force-with-lease)
alias gpl='git pull'
alias gpm='git pull origin main'
alias gf='git fetch'

# Diff & Log
alias gd='git diff'
alias gdc='git dc'           # uses gitconfig alias (diff --cached)
alias gl='git lol'           # uses gitconfig alias (log graph oneline)
alias glol='git lol'
alias glola='git lola'       # uses gitconfig alias (log graph all)

# Rebase & Merge
alias grm='git rebasemain'   # uses gitconfig alias (pull origin main -r)
alias gri='git rebase -i HEAD~'
alias gcp='git cherry-pick'

# Stash
alias gstash='git staash'    # uses gitconfig alias (stash --include-untracked)
alias gundo='git undo'       # uses gitconfig alias (reset --soft HEAD^)

# Recent branches (quick reference)
alias gbr='git for-each-ref --sort=-committerdate refs/heads/ --format="%(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) (%(color:green)%(committerdate:relative)%(color:reset))" | head -n 10'
