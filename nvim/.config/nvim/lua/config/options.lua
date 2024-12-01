-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/luautochdira/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- ensure that the file tree always is based on the root of where nvim was started
vim.g.root_spec = {}
opt.autochdir = false
opt.wrap = true
opt.scrolloff = 8

opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.backspace = { "indent", "eol", "start" }
opt.path:append("**")
opt.wildignore:append("*/node_modules/*")

-- disable format on save can format using cf or cF
-- vim.g.autoformat = false

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "solargraph"
vim.g.lazyvim_ruby_formatter = "rubocop"
