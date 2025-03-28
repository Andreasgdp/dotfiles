-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function feedkeys(key, mode)
  local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(keys, mode, true)
end

-- When opening the first and only the first file, run :Gitsigns toggle_current_line_blame<CR>
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  once = true,
  callback = function()
    vim.defer_fn(function()
      vim.cmd("Gitsigns toggle_current_line_blame")
    end, 100)
  end,
})

-- when entering insert mode, trigger copilot to generate a suggestion
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      -- TODO: fiture out how to make this work for the lazuvim installment of copilot
      feedkeys("<space><BS>", "n")
    end, 100)
  end,
})
-- When the window is scrolled, resized, or about to quit, show the scrollbar
vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized", "QuitPre", "WinEnter", "FocusGained" }, {
  pattern = "*",
  callback = function()
    vim.cmd("silent! lua require('scrollbar').show()")
  end,
})

-- When leaving a window, buffer, or losing focus, clear the scrollbar
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "BufWinLeave", "FocusLost" }, {
  pattern = "*",
  callback = function()
    vim.cmd("silent! lua require('scrollbar').clear()")
  end,
})
