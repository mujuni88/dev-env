# Nushell Config File

# Load environment config
source ~/.config/nushell/env.nu

# Aliases
alias ls = eza --color=always --long --git --icons=always --no-time --no-user --all --tree --level=1 --git-ignore
alias cat = bat
alias df = df -h
alias rm = rm -i
alias cp = cp -i

# Navigation aliases
def devenv [] { cd $env.MY_DEV }
def devedit [] { cd $env.MY_DEV; nvim . }
def dots [] { cd $"($env.MY_DEV)/dotfiles" }
def dotsedit [] { cd $"($env.MY_DEV)/dotfiles"; nvim . }

# Editor aliases
alias vi = nvim
alias vim = nvim

# Tmux aliases
alias tmn = tmux new-session -s
alias tma = tmux attach -t
alias tml = tmux ls
alias tmk = tmux kill-session -t
alias tmd = tmux detach -a
alias tmka = killall tmux

# Development aliases
alias pgstart = brew services start postgresql@16
alias pgstop = brew services stop postgresql@16
alias pg = psql postgres

# Nix aliases
def nixswitch [] {
    cd $env.MY_NIX
    darwin-rebuild switch --flake $"($env.MY_NIX)#macos"
    nix-collect-garbage --delete-old
}

def nixup [] {
    cd $env.MY_NIX
    nix flake update
    nixswitch
}

def nixedit [] { cd $env.MY_NIX; nvim . }

# Netflix Development aliases
def Netflix [] { cd $"($env.HOME)/Code/Netflix" }
def auiroot [] { Netflix; cd ai-animation-ui }
def caroot [] { Netflix; cd pxd-spotlight-ui }
def killuiport [] { 
    killport 8180
    killport 8080
    killport 3000 
}

# Show PATH entries one per line
def path [] {
    $env.PATH | split row (char esep) | each { |it| echo $it }
}

# Use zoxide for cd
alias cd = z
alias j = z

# Useful default options
$env.config = {
    show_banner: false,    # Hide the welcome banner
    ls: {
        use_ls_colors: true,
        clickable_links: true,
    },
    rm: {
        always_trash: false,
    },
    table: {
        mode: rounded,
        index_mode: always,
        trim: {
            methodology: wrapping,
            wrapping_try_keep_words: true,
        }
    },
    history: {
        max_size: 10000,
        sync_on_enter: true,
        file_format: "plaintext"
    },
    completions: {
        case_sensitive: false,
        quick: true,
        partial: true,
        algorithm: "prefix"
    }
}

# Load Starship prompt (if installed)
if (which starship | is-empty) == false {
    mkdir ~/.cache/starship
    starship init nu | save -f ~/.cache/starship/init.nu
    source ~/.cache/starship/init.nu
}

# Load Zoxide (if installed)
if (which zoxide | is-empty) == false {
    zoxide init nushell | save -f ~/.zoxide.nu
    source ~/.zoxide.nu
}