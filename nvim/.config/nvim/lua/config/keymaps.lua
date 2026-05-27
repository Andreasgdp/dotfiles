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

-- Text Formatting
map("x", "<leader>gq", "gq", { desc = "Format to textwidth" })

local function navigate_pane(wincmd, dir)
  local prev = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() ~= prev then
    return
  end

  if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--current" })
  elseif vim.env.TMUX and vim.env.TMUX ~= "" then
    local tmux = { left = "Left", down = "Down", up = "Up", right = "Right" }
    pcall(vim.cmd, "TmuxNavigate" .. tmux[dir])
  end
end

-- Load after LazyVim's default <C-h/j/k/l> window mappings so these win.
map("n", "<C-h>", function()
  navigate_pane("h", "left")
end, { silent = true, noremap = true, desc = "Navigate left (vim/herdr)" })
map("n", "<C-j>", function()
  navigate_pane("j", "down")
end, { silent = true, noremap = true, desc = "Navigate down (vim/herdr)" })
map("n", "<C-k>", function()
  navigate_pane("k", "up")
end, { silent = true, noremap = true, desc = "Navigate up (vim/herdr)" })
map("n", "<C-l>", function()
  navigate_pane("l", "right")
end, { silent = true, noremap = true, desc = "Navigate right (vim/herdr)" })
