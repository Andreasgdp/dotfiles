-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local map = vim.keymap.set

-- Editor
map("n", "<C-q>", "<cmd>qa<cr>", { desc = "Quit All", remap = true })
map("n", "<C-S>", ":wa<CR>", { desc = "Save all buffers", remap = true })
map("n", "<leader>fF", function()
  Snacks.picker.pick("files")
end, { desc = "Find Files (Root Dir)", remap = true })
map("n", "<leader>ff", function()
  Snacks.picker.pick("files", { root = false })
end, { desc = "Find Files (cwd)", remap = true })
map("n", "<leader><leader>", function()
  Snacks.picker.pick("files", { root = false })
end, { desc = "Find Files (cwd)", remap = true })

-- LSP
map("n", "<leader>rl", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Git
map("n", "<C-g>", function()
  Snacks.lazygit({ cwd = Util.root.git() })
end, { desc = "Lazygit (Root Dir)" })
map("n", "<leader>gb", ":G blame<CR>", { silent = true, remap = true, desc = "Neogit Blame" })

map("n", "<leader>gd", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end, { silent = true, remap = true, desc = "Neogit Diff" })
