-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local map = vim.keymap.set

-- Editor
map("n", "<C-q>", "<cmd>qa<cr>", { desc = "Quit All", remap = true })
map("n", "<C-S>", ":wa<CR>", { desc = "Save all buffers", remap = true })

-- LSP
map("n", "<leader>rl", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Git
map("n", "<C-g>", function()
  Snacks.lazygit({ cwd = Util.root.git() })
end, { desc = "Lazygit (Root Dir)" })
