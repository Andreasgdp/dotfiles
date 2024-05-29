-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Old remaps are here: https://github.com/Andreasgdp/nvim/blob/6992433392cf6d9c5612de385d8e83d6487a9750/lua/theprimeagen/remap.lua
-- Custom LazyVim editor keymaps are here: https://github.com/LazyVim/LazyVim/blob/6b68378c2c5a6d18b1b4c5ca4c71441997921200/lua/lazyvim/plugins/editor.lua#L95
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<C-p>", Util.telescope("files"), { desc = "Telescope Files", remap = true })
-- ---------GIT---------
-- Open command-line window with ":Git " pre-filled
map("n", "<leader>g<leader>", ":Git ", { desc = "Git" })

local neogit = require("neogit")

-- status
map("n", "<leader>gs", neogit.open, { silent = true, remap = true, desc = "Neogit Status" })
map("n", "<leader>gl", neogit.open, { silent = true, remap = true, desc = "Neogit Status" })
-- commit
map("n", "<leader>gc", ":Neogit commit<CR>", { silent = true, remap = true, desc = "Neogit Commit" })
-- pull
map("n", "<leader>gp", ":Neogit pull<CR>", { silent = true, remap = true, desc = "Neogit Pull" })
-- push
map("n", "<leader>gP", ":Neogit push<CR>", { silent = true, remap = true, desc = "Neogit Push" })
-- branches
map("n", "<leader>gb", ":Telescope git_branches<CR>", { silent = true, remap = true, desc = "Search branches" })
-- blame
map("n", "<leader>gB", ":G blame<CR>", { silent = true, remap = true, desc = "Neogit Blame" })
-- diffview toggle (:DiffviewOpen, :DiffviewClose depending on state)
map("n", "<leader>gd", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end, { silent = true, remap = true, desc = "Neogit Diff" })
-- ---------GIT---------

vim.keymap.del("i", "<Tab>")
vim.g.copilot_no_tab_map = true
-- enable/disable copilot 'Copilot enable'
map("n", "<leader>cp", function()
  if require("copilot.client").is_disabled() then
    vim.cmd("Copilot enable")
  else
    vim.cmd("Copilot disable")
  end
end, { desc = "Copilot toggle" })

map("n", "<leader>cP", function()
  vim.cmd("Copilot enable")
end, { desc = "Copilot enable" })

-- Make Ctrl+C equivalent to Esc in insert mode (https://vi.stackexchange.com/a/25765)
map("i", "<C-c>", "<Esc>", { desc = "Ctrl+C to Esc" })

map("n", "<A-S-j>", ":t .<CR>", { desc = "Copy line down" })
map("n", "<A-S-k>", ":t .-1<CR>", { desc = "Copy line up" })

-- enable ctrl+backspace to delete word in insert mode (NOTE: <C-BS> maybe only work on vim gui apps... if you use vim terminal, <C-BS> normally don't work.)
-- https://www.reddit.com/r/neovim/comments/okbag3/comment/h57auji/?utm_source=share&utm_medium=web2x&context=3
map("i", "<C-H>", "<C-w>", { desc = "Ctrl+Backspace to delete word", silent = true, remap = true })

-- map ctrl+q to increment number under cursor as ctrl+a is mapped in tmux as prefix
map("n", "<C-q>", "<C-a>", { desc = "Increment number under cursor" })

-- map <leader>/ to <cmd>Telescope current_buffer_fuzzy_find<cr>
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Telescope current buffer fuzzy find" })

local ts_builtin = require("telescope.builtin")
local ts_utils = require("telescope.utils")

-- telescope find files in project
map("n", "<leader>ff", ts_builtin.find_files, { desc = "Telescope Find Files", remap = true })
-- telescope find files in cwd
map("n", "<leader>fF", function()
  ts_builtin.find_files({ cwd = ts_utils.buffer_dir() })
end, { desc = "Telescope Find Files in CWD", remap = true })

local apm = require("vim-apm")
apm:setup({})
vim.keymap.set("n", "<leader>apm", function()
  apm:toggle_monitor()
end, { desc = "APM toggle monitor" })

-- windows
map("n", "<leader>ww", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>wk", "<C-W>s", { desc = "Split Window Above", remap = true })
map("n", "<leader>wj", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>wl", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wl", "<C-W>v", { desc = "Split Window Left", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- remove all marks
map("n", "<leader>mm", ":delmarks a-z<CR>", { desc = "Delete all marks" })
-- remove all marks for alphanumeric characters and special characters
map("n", "<leader>ma", ":delm! | delm A-Z0-9<CR>", { desc = "Delete all marks for alphanumeric characters" })
