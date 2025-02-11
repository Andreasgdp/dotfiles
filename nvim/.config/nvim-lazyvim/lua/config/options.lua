-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- ensure that the file tree always is based on the root of where nvim was started
vim.g.root_spec = {}
opt.autochdir = false
opt.wrap = true
opt.scrolloff = 8

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = true

-- disable format on save can format using cf or cF
-- vim.g.autoformat = false
