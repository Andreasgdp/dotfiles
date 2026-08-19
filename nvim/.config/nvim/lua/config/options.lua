-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- ensure that the file tree always is based on the root of where nvim was started
vim.g.root_spec = {}
opt.autochdir = false
opt.wrap = true
opt.scrolloff = 8
opt.colorcolumn = "+1" -- Show ruler at textwidth + 1

vim.opt.swapfile = false

-- use spaces instead of tabs and set the tab width to 4
opt.expandtab = true
opt.tabstop = 4

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = true

-- disable format on save can format using cf or cF
-- vim.g.autoformat = false

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"
