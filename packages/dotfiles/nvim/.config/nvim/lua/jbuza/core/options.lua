vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for a tab (pretter default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- convert tabs to spaces
opt.smarttab = true -- tab key indents/outdents by default
opt.autoindent = true -- copy indent from current line

opt.wrap = false -- don't wrap lines

-- search settings
opt.ignorecase = true -- ignore case in search
opt.smartcase = true -- case-sensitive if search pattern is all lowercase
-- opt.hlsearch = true -- highlight matches
-- opt.incsearch = true -- incremental search

-- cursor settings
opt.cursorline = true -- highlight current line
opt.cursorcolumn = true -- highlight current column

-- colors 
opt.termguicolors = true -- enable true color support
opt.background = "dark" -- set background to dark
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

--  clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register


-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
