-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- When opening the first and only the first file, run :Gitsigns toggle_current_line_blame<CR>

local function feedkeys(key, mode)
  local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(keys, mode, true)
end

-- when opening the first and only the first file,
-- run :Gitsigns toggle_current_line_blame<CR>
-- This then enables further showing of git blame information
-- as it is now loaded into the buffer
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  once = true,
  callback = function()
    vim.cmd("Gitsigns toggle_current_line_blame")
  end,
})

-- when entering insert mode, trigger copilot to generate a suggestion
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      feedkeys("<space><BS>", "n")
    end, 100)
  end,
})
