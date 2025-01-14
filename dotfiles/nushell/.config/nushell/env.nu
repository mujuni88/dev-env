# env.nu
#
# Installed by:
# version = "0.101.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# Nushell Environment Config File
# Environment variables
$env.MY_DEV = $"($env.HOME)/dev-env"
$env.MY_NIX = $"($env.MY_DEV)/nix"
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.EDITOR = "cursor"
$env.VISUAL = "nvim"
$env.BAT_THEME = "tokyonight_night"
$env.SDKMAN_DIR = $"($env.HOME)/.sdkman"
$env.BUN_INSTALL = $"($env.HOME)/.bun"
$env.PKG_CONFIG_PATH = "/opt/homebrew/opt/postgresql@16/lib/pkgconfig"

# PATH Setup
$env.PATH = ([
    $"($env.HOME)/bin"
    $"($env.HOME)/.local/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/mysql-client/bin"
    "/opt/homebrew/opt/postgresql@16/bin"
    $"($env.BUN_INSTALL)/bin"
    $"($env.HOME)/.console-ninja/.bin"
    $"($env.HOME)/.codeium/windsurf/bin"
    $env.PATH
] | uniq)